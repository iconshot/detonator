package com.iconshot.detonator;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import android.webkit.JavascriptInterface;
import android.webkit.ValueCallback;
import android.webkit.WebView;

import android.os.Handler;
import android.os.Looper;

import java.lang.reflect.Constructor;
import java.util.HashMap;
import java.util.Map;

import com.iconshot.detonator.renderer.Renderer;

import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.element.ActivityIndicatorElement;
import com.iconshot.detonator.element.IconElement;
import com.iconshot.detonator.element.SafeAreaViewElement;
import com.iconshot.detonator.element.horizontalscrollviewelement.HorizontalScrollViewElement;
import com.iconshot.detonator.element.verticalscrollviewelement.VerticalScrollViewElement;
import com.iconshot.detonator.element.imageelement.ImageElement;
import com.iconshot.detonator.element.InputElement;
import com.iconshot.detonator.element.TextAreaElement;
import com.iconshot.detonator.element.TextElement;
import com.iconshot.detonator.element.AudioElement;
import com.iconshot.detonator.element.videoelement.VideoElement;
import com.iconshot.detonator.element.viewelement.ViewElement;

import com.iconshot.detonator.emitter.EventEmitter;
import com.iconshot.detonator.emitter.HandlerEmitter;

import com.iconshot.detonator.request.Request;
import com.iconshot.detonator.request.OpenUrlRequest;
import com.iconshot.detonator.request.InputBlurRequest;
import com.iconshot.detonator.request.InputFocusRequest;
import com.iconshot.detonator.request.InputSetValueRequest;
import com.iconshot.detonator.request.ImageGetSizeRequest;
import com.iconshot.detonator.request.TextAreaBlurRequest;
import com.iconshot.detonator.request.TextAreaFocusRequest;
import com.iconshot.detonator.request.TextAreaSetValueRequest;
import com.iconshot.detonator.request.ToastShowRequest;
import com.iconshot.detonator.request.VideoPauseRequest;
import com.iconshot.detonator.request.VideoPlayRequest;
import com.iconshot.detonator.request.VideoSeekRequest;
import com.iconshot.detonator.request.AudioPauseRequest;
import com.iconshot.detonator.request.AudioPlayRequest;
import com.iconshot.detonator.request.AudioSeekRequest;

import com.iconshot.detonator.module.Module;
import com.iconshot.detonator.module.AppStateModule;
import com.iconshot.detonator.module.StorageModule;
import com.iconshot.detonator.module.stylesheet.StyleSheetModule;
import com.iconshot.detonator.module.fullscreen.FullScreenModule;

import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.FileHelper;

import com.iconshot.detonator.layout.ViewLayout;

import com.iconshot.detonator.renderer.Edge;

public class Detonator {
    private final String path;

    private final Renderer renderer;

    private final Map<String, MessageHandler> messageHandlers;

    private final Map<String, Class<? extends Element>> elementClasses;
    private final Map<String, Class<? extends Request>> requestClasses;
    private final Map<String, Class<? extends Module>> moduleClasses;

    private final Map<String, Module> modules;

    private final HandlerEmitter handlerEmitter;
    private final EventEmitter eventEmitter;

    private final Handler uiHandler;
    private final Gson gson;

    private WebView webView;

    public Detonator(ViewLayout rootView, String path) {
        this.path = path;

        messageHandlers = new HashMap<>();

        elementClasses = new HashMap<>();
        requestClasses = new HashMap<>();
        moduleClasses = new HashMap<>();

        modules = new HashMap<>();

        handlerEmitter = new HandlerEmitter(this);
        eventEmitter = new EventEmitter(this);

        renderer = new Renderer(this, rootView);

        if (ContextHelper.context == null) {
            ContextHelper.context = rootView.getContext();
        }

        uiHandler = new Handler(Looper.getMainLooper());

        GsonBuilder builder = new GsonBuilder();

        builder.serializeNulls();

        gson = builder.create();

        addMessageHandler("com.iconshot.detonator/request", (dataString) -> {
            Request.IncomingRequest incomingRequest = decode(dataString, Request.IncomingRequest.class);

            Class<? extends Request> requestClass = requestClasses.get(incomingRequest.name);

            if (requestClass == null) {
                return;
            }

            Request request;

            try {
                Constructor<? extends Request> constructor;

                constructor = requestClass.getDeclaredConstructor(
                        Detonator.class,
                        Request.IncomingRequest.class
                );

                request = constructor.newInstance(this, incomingRequest);
            } catch (Exception e) {
                return;
            }

            request.run();
        });

        addMessageHandler("com.iconshot.detonator/log", dataString -> {
            String str = dataString.substring(1, dataString.length() - 1);

            System.out.println(str);
        });

        addElementClass("com.iconshot.detonator.view", ViewElement.class);
        addElementClass("com.iconshot.detonator.text", TextElement.class);
        addElementClass("com.iconshot.detonator.input", InputElement.class);
        addElementClass("com.iconshot.detonator.textarea", TextAreaElement.class);
        addElementClass("com.iconshot.detonator.image", ImageElement.class);
        addElementClass("com.iconshot.detonator.video", VideoElement.class);
        addElementClass("com.iconshot.detonator.audio", AudioElement.class);
        addElementClass("com.iconshot.detonator.verticalscrollview", VerticalScrollViewElement.class);
        addElementClass("com.iconshot.detonator.horizontalscrollview", HorizontalScrollViewElement.class);
        addElementClass("com.iconshot.detonator.safeareaview", SafeAreaViewElement.class);
        addElementClass("com.iconshot.detonator.icon", IconElement.class);
        addElementClass("com.iconshot.detonator.activityindicator", ActivityIndicatorElement.class);

        addRequestClass("com.iconshot.detonator/openUrl", OpenUrlRequest.class);
        addRequestClass("com.iconshot.detonator.input/focus", InputFocusRequest.class);
        addRequestClass("com.iconshot.detonator.input/blur", InputBlurRequest.class);
        addRequestClass("com.iconshot.detonator.input/setValue", InputSetValueRequest.class);
        addRequestClass("com.iconshot.detonator.textarea/focus", TextAreaFocusRequest.class);
        addRequestClass("com.iconshot.detonator.textarea/blur", TextAreaBlurRequest.class);
        addRequestClass("com.iconshot.detonator.textarea/setValue", TextAreaSetValueRequest.class);
        addRequestClass("com.iconshot.detonator.image/getSize", ImageGetSizeRequest.class);
        addRequestClass("com.iconshot.detonator.video/play", VideoPlayRequest.class);
        addRequestClass("com.iconshot.detonator.video/pause", VideoPauseRequest.class);
        addRequestClass("com.iconshot.detonator.video/seek", VideoSeekRequest.class);
        addRequestClass("com.iconshot.detonator.audio/play", AudioPlayRequest.class);
        addRequestClass("com.iconshot.detonator.audio/pause", AudioPauseRequest.class);
        addRequestClass("com.iconshot.detonator.audio/seek", AudioSeekRequest.class);
        addRequestClass("com.iconshot.detonator.toast/show", ToastShowRequest.class);

        addModuleClass("com.iconshot.detonator.appstate", AppStateModule.class);
        addModuleClass("com.iconshot.detonator.storage", StorageModule.class);
        addModuleClass("com.iconshot.detonator.fullscreen", FullScreenModule.class);
        addModuleClass("com.iconshot.detonator.stylesheet", StyleSheetModule.class);

        initWebView();

        collectModuleClasses();

        registerModules();
    }

    private void initWebView() {
        webView = new WebView(ContextHelper.context);

        webView.getSettings().setJavaScriptEnabled(true);

        webView.addJavascriptInterface(this, "DetonatorBridge");

        evaluate("window.__detonator_platform = \"android\"");

        String code = FileHelper.readFileFromAssets(path);

        evaluate(code);
    }

    public <T> T decode(String data, Class<T> dataClass) {
        return gson.fromJson(data, dataClass);
    }

    public Edge getEdge(int edgeId) {
        return renderer.edges.get(edgeId);
    }

    public Class<? extends Element> getElementClass(String key) {
        return elementClasses.get(key);
    }

    public MessageHandler getMessageHandler(String key) {
        return messageHandlers.get(key);
    }

    public void addMessageHandler(String key, MessageHandler messageHandler) {
        messageHandlers.put(key, messageHandler);
    }

    public void addElementClass(String key, Class<? extends Element> elementClass) {
        elementClasses.put(key, elementClass);
    }

    public Class<? extends Request> getRequestClass(String key) {
        return requestClasses.get(key);
    }

    public void addRequestClass(String key, Class<? extends Request> requestClass) {
        requestClasses.put(key, requestClass);
    }

    public Class<? extends Module> getModuleClass(String key) {
        return moduleClasses.get(key);
    }

    public void addModuleClass(String key, Class<? extends Module> moduleClass) {
        moduleClasses.put(key, moduleClass);
    }

    private void evaluate(String code) {
        webView.evaluateJavascript(code, new ValueCallback<String>() {
            @Override
            public void onReceiveValue(String value) { }
        });
    }

    public void emit(String name, Object value) {
        String json = gson.toJson(value);

        String escape = json
                .replaceAll("\\\\", "\\\\\\\\")
                .replaceAll("\"", "\\\\\"");

        String code = "window.Detonator.emitter.emit(\"" + name + "\", \"" + escape + "\");";

        evaluate(code);
    }

    public void emitHandler(String name, int edgeId) {
        emitHandler(name, edgeId, null);
    }

    public void emitHandler(String name, int edgeId, Object data) {
        handlerEmitter.emit(name, edgeId, data);
    }

    public void emitEvent(String name) {
        emitEvent(name, null);
    }

    public void emitEvent(String name, Object data) {
        eventEmitter.emit(name, data);
    }

    private void collectModuleClasses() {

    }

    private void registerModules() {
        for (Map.Entry<String, Class<? extends Module>> entry : moduleClasses.entrySet()) {
            String key = entry.getKey();

            Class<? extends Module> moduleClass = entry.getValue();

            Module module;

            try {
                Constructor<? extends Module> constructor;

                constructor = moduleClass.getDeclaredConstructor(Detonator.class);

                module = constructor.newInstance(Detonator.this);
            } catch (Exception e) {
                continue;
            }

            module.register();

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
            String[] parts = messageString.split("\n");

            String name = parts[0];
            String data = parts[1];

            MessageHandler messageHandler = messageHandlers.get(name);

            if (messageHandler == null) {
                return;
            }

            messageHandler.handle(data);
        });
    }

    @FunctionalInterface
    public interface MessageHandler {
        void handle(String dataString);
    }
}
