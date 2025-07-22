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
import java.util.HashMap;
import java.util.Map;

import com.iconshot.detonator.module.FileStreamModule;
import com.iconshot.detonator.renderer.Renderer;
import com.iconshot.detonator.renderer.Edge;

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
import com.iconshot.detonator.module.fullscreen.FullScreenModule;
import com.iconshot.detonator.module.StorageModule;
import com.iconshot.detonator.module.stylesheet.StyleSheetModule;

import com.iconshot.detonator.helpers.FileHelper;

import com.iconshot.detonator.layout.ViewLayout;

public class Detonator {
    private final String path;

    private final Renderer renderer;

    private final Map<String, MessageListener> messageListeners;

    private final Map<String, Class<? extends Element>> elementClasses;
    private final Map<String, Class<? extends Request>> requestClasses;
    private final Map<String, Class<? extends Module>> moduleClasses;

    private final Map<String, Module> modules;

    public final Handler uiHandler;
    public final Context context;
    private final Gson gson;

    private WebView webView;

    public Detonator(ViewLayout rootView, String path) {
        this.path = path;

        messageListeners = new HashMap<>();

        elementClasses = new HashMap<>();
        requestClasses = new HashMap<>();
        moduleClasses = new HashMap<>();

        modules = new HashMap<>();

        renderer = new Renderer(this, rootView);

        context = rootView.getContext();

        uiHandler = new Handler(Looper.getMainLooper());

        GsonBuilder builder = new GsonBuilder();

        builder.serializeNulls();

        gson = builder.create();

        setMessageListener("com.iconshot.detonator.request::init", (value) -> {
            Request.IncomingRequest incomingRequest = decode(value, Request.IncomingRequest.class);

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

        setMessageListener("com.iconshot.detonator::log", value -> {
            String str = value.substring(1, value.length() - 1);

            System.out.println(str);
        });

        setElementClass("com.iconshot.detonator.view", ViewElement.class);
        setElementClass("com.iconshot.detonator.text", TextElement.class);
        setElementClass("com.iconshot.detonator.input", InputElement.class);
        setElementClass("com.iconshot.detonator.textarea", TextAreaElement.class);
        setElementClass("com.iconshot.detonator.image", ImageElement.class);
        setElementClass("com.iconshot.detonator.video", VideoElement.class);
        setElementClass("com.iconshot.detonator.audio", AudioElement.class);
        setElementClass("com.iconshot.detonator.verticalscrollview", VerticalScrollViewElement.class);
        setElementClass("com.iconshot.detonator.horizontalscrollview", HorizontalScrollViewElement.class);
        setElementClass("com.iconshot.detonator.safeareaview", SafeAreaViewElement.class);
        setElementClass("com.iconshot.detonator.icon", IconElement.class);
        setElementClass("com.iconshot.detonator.activityindicator", ActivityIndicatorElement.class);

        setRequestClass("com.iconshot.detonator::openUrl", OpenUrlRequest.class);
        setRequestClass("com.iconshot.detonator.input::focus", InputFocusRequest.class);
        setRequestClass("com.iconshot.detonator.input::blur", InputBlurRequest.class);
        setRequestClass("com.iconshot.detonator.input::setValue", InputSetValueRequest.class);
        setRequestClass("com.iconshot.detonator.textarea::focus", TextAreaFocusRequest.class);
        setRequestClass("com.iconshot.detonator.textarea::blur", TextAreaBlurRequest.class);
        setRequestClass("com.iconshot.detonator.textarea::setValue", TextAreaSetValueRequest.class);
        setRequestClass("com.iconshot.detonator.image::getSize", ImageGetSizeRequest.class);
        setRequestClass("com.iconshot.detonator.video::play", VideoPlayRequest.class);
        setRequestClass("com.iconshot.detonator.video::pause", VideoPauseRequest.class);
        setRequestClass("com.iconshot.detonator.video::seek", VideoSeekRequest.class);
        setRequestClass("com.iconshot.detonator.audio::play", AudioPlayRequest.class);
        setRequestClass("com.iconshot.detonator.audio::pause", AudioPauseRequest.class);
        setRequestClass("com.iconshot.detonator.audio::seek", AudioSeekRequest.class);
        setRequestClass("com.iconshot.detonator.toast::show", ToastShowRequest.class);

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

    public MessageListener getMessageListener(String key) {
        return messageListeners.get(key);
    }

    public void setMessageListener(String key, MessageListener messageListener) {
        messageListeners.put(key, messageListener);
    }

    public Class<? extends Element> getElementClass(String key) {
        return elementClasses.get(key);
    }


    public void setElementClass(String key, Class<? extends Element> elementClass) {
        elementClasses.put(key, elementClass);
    }

    public Class<? extends Request> getRequestClass(String key) {
        return requestClasses.get(key);
    }

    public void setRequestClass(String key, Class<? extends Request> requestClass) {
        requestClasses.put(key, requestClass);
    }

    public Class<? extends Module> getModuleClass(String key) {
        return moduleClasses.get(key);
    }

    public void setModuleClass(String key, Class<? extends Module> moduleClass) {
        moduleClasses.put(key, moduleClass);
    }

    public Module getModule(String key) {
        return modules.get(key);
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

    public void emit(String name, String value) {
        String escapedValue = value
                .replaceAll("\\\\", "\\\\\\\\")
                .replaceAll("`", "\\\\`");

        String code = "window.Detonator.emitter.emit(`" + name + "`, `" + escapedValue + "`);";

        evaluate(code);
    }

    public void emit(String name, Object object) {
        String value = encode(object);

        emit(name, value);
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
            String[] pieces = messageString.split("\n", 2);

            String name = pieces[0];
            String value = pieces[1];

            MessageListener messageListener = messageListeners.get(name);

            if (messageListener == null) {
                return;
            }

            messageListener.call(value);
        });
    }

    @FunctionalInterface
    public interface MessageListener {
        void call(String value);
    }
}
