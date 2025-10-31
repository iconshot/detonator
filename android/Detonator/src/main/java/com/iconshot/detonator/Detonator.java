package com.iconshot.detonator;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import android.content.Context;
import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebView;

import android.os.Handler;
import android.os.Looper;

import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.module.FileStreamModule;
import com.iconshot.detonator.module.UIModule;
import com.iconshot.detonator.module.UtilityModule;
import com.iconshot.detonator.renderer.Renderer;
import com.iconshot.detonator.renderer.Edge;

import com.iconshot.detonator.module.Module;
import com.iconshot.detonator.module.AppStateModule;
import com.iconshot.detonator.module.FullScreenModule;
import com.iconshot.detonator.module.StorageModule;
import com.iconshot.detonator.module.stylesheet.StyleSheetModule;

import com.iconshot.detonator.helpers.FileHelper;

import com.iconshot.detonator.layout.ViewLayout;

public class Detonator {
    private final String path;

    private final Renderer renderer;

    public final MessageFormatter messageFormatter;

    private final Map<String, EventListener> eventListeners;

    private final Map<String, RequestListener> requestListeners;

    private final Map<String, Class<? extends Module>> moduleClasses;
    private final Map<String, Class<? extends Element>> elementClasses;

    private final Map<String, Module> modules;

    public final Handler uiHandler;
    public final Context context;
    private final Gson gson;

    private WebView webView;

    public Detonator(ViewLayout rootView, String path) {
        this.path = path;

        eventListeners = new HashMap<>();
        requestListeners = new HashMap<>();

        elementClasses = new HashMap<>();
        moduleClasses = new HashMap<>();

        modules = new HashMap<>();

        renderer = new Renderer(this, rootView);

        messageFormatter = new MessageFormatter(this);

        context = rootView.getContext();

        uiHandler = new Handler(Looper.getMainLooper());

        GsonBuilder builder = new GsonBuilder();

        builder.serializeNulls();

        gson = builder.create();

        setEventListener("com.iconshot.detonator.request::fetch", (value) -> {
            List<String> parts = messageFormatter.split(value, 4);

            int fetchId = Integer.parseInt(parts.get(0));
            Integer edgeId = !parts.get(1).equals("-") ? Integer.parseInt(parts.get(1)) : null;
            String name = parts.get(2);
            String dataValue = parts.get(3);

            RequestPromise promise = new RequestPromise(this, fetchId);

            Edge edge = null;

            if (edgeId != null) {
                edge = getEdge(edgeId);

                if (edge.element != null) {
                    ElementRequestListener elementRequestListener = edge.element.getRequestListener(name);

                    if (elementRequestListener != null) {
                        elementRequestListener.call(promise, dataValue);

                        return;
                    }
                }
            }

            RequestListener requestListener = requestListeners.get(name);

            if (requestListener == null) {
                promise.reject("No request listener found for \"" + name + "\".");

                return;
            }

            requestListener.call(promise, dataValue, edge);
        });

        setModuleClass("com.iconshot.detonator.ui", UIModule.class);
        setModuleClass("com.iconshot.detonator.utility", UtilityModule.class);
        setModuleClass("com.iconshot.detonator.appstate", AppStateModule.class);
        setModuleClass("com.iconshot.detonator.storage", StorageModule.class);
        setModuleClass("com.iconshot.detonator.fullscreen", FullScreenModule.class);
        setModuleClass("com.iconshot.detonator.stylesheet", StyleSheetModule.class);
        setModuleClass("com.iconshot.detonator.filestream", FileStreamModule.class);
    }

    public void initialize() {
        initializeWebView();

        initializeModules();
    }

    private void initializeWebView() {
        webView = new WebView(context);

        webView.getSettings().setJavaScriptEnabled(true);

        webView.addJavascriptInterface(this, "DetonatorBridge");

        evaluate("window.__detonator_platform = \"android\"");

        String code = FileHelper.readFileFromAssets(context, path);

        evaluate(code);
    }

    public Edge getEdge(int edgeId) {
        return renderer.edges.get(edgeId);
    }

    public void setEventListener(String key, EventListener messageListener) {
        eventListeners.put(key, messageListener);
    }

    public void setRequestListener(String key, RequestListener requestListener) {
        requestListeners.put(key, requestListener);
    }

    public void setModuleClass(String key, Class<? extends Module> moduleClass) {
        moduleClasses.put(key, moduleClass);
    }

    public Class<? extends Element> getElementClass(String key) {
        return elementClasses.get(key);
    }

    public void setElementClass(String key, Class<? extends Element> elementClass) {
        elementClasses.put(key, elementClass);
    }

    public String encode(Object data) {
        return gson.toJson(data);
    }

    public <T> T decode(String value, Class<T> dataClass) {
        return gson.fromJson(value, dataClass);
    }

    private void evaluate(String code) {
        webView.evaluateJavascript(code, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String value) { }
        });
    }

    public void send(String name) {
        send(name, "");
    }

    public void send(String name, Object data) {
        List<Object> lines = new ArrayList<>();

        lines.add(data);

        send(name, lines);
    }

    private void send(String name, List<Object> lines) {
        String value = messageFormatter.join(lines)
                .replaceAll("\\\\", "\\\\\\\\")
                .replaceAll("`", "\\\\`");

        String code = "window.Detonator.emitter.emit(`" + name + "`, `" + value + "`);";

        evaluate(code);
    }

    private void initializeModules() {
        for (Map.Entry<String, Class<? extends Module>> entry : moduleClasses.entrySet()) {
            String key = entry.getKey();

            Class<? extends Module> moduleClass = entry.getValue();

            Module module;

            try {
                Constructor<? extends Module> constructor;

                constructor = moduleClass.getDeclaredConstructor(Detonator.class);

                module = constructor.newInstance(this);
            } catch (Exception e) {
                continue;
            }

            module.setUp();

            modules.put(key, module);
        }
    }

    public void performLayout() {
        this.renderer.performLayout();
    }

    @JavascriptInterface
    public void postMessage(String messageString) {
        /*

        why the uiHandler.post?

        the postMessage is executed on a background thread
        and the UI operations (like creating or modifying views)
        must occur on the UI thread

        if we don't use the uiHandler, the calls to mount, rerender, etc
        would happen on the background thread,
        causing crashes and undefined behavior

        */

        uiHandler.post(() -> {
            List<String> parts = messageFormatter.split(messageString, 2);

            String name = parts.get(0);
            String value = parts.get(1);

            EventListener eventListener = eventListeners.get(name);

            if (eventListener == null) {
                return;
            }

            eventListener.call(value);
        });
    }

    @FunctionalInterface
    public interface EventListener {
        void call(String value);
    }

    @FunctionalInterface
    public interface RequestListener {
        void call(RequestPromise promise, String value, Edge edge);
    }

    @FunctionalInterface
    public interface ElementRequestListener {
        void call(RequestPromise promise, String value);
    }
}
