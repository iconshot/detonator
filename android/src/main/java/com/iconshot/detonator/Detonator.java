package com.iconshot.detonator;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import android.view.ViewGroup;
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
import com.iconshot.detonator.element.Style;

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
import com.iconshot.detonator.module.fullscreen.FullScreenModule;

import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.FileHelper;

import com.iconshot.detonator.layout.ViewLayout;


import com.iconshot.detonator.tree.Tree;
import com.iconshot.detonator.tree.Edge;
import com.iconshot.detonator.tree.Target;

public class Detonator {
    private final String path;
    private final Map<String, Class<? extends Element>> elementClasses;
    private final Map<String, Class<? extends Request>> requestClasses;
    private final Map<String, Class<? extends Module>> moduleClasses;
    private final Map<String, Module> modules;
    private final HandlerEmitter handlerEmitter;
    private final EventEmitter eventEmitter;
    private final Map<Integer, Tree> trees;
    private final Map<Integer, Edge> edges;
    private final Handler uiHandler;
    public final Gson gson;
    private WebView webView;
    private final ViewLayout rootView;

    public Detonator(ViewLayout rootView, String path) {
        this.path = path;
        this.rootView = rootView;

        elementClasses = new HashMap<>();
        requestClasses = new HashMap<>();
        moduleClasses = new HashMap<>();

        modules = new HashMap<>();

        handlerEmitter = new HandlerEmitter(this);
        eventEmitter = new EventEmitter(this);

        trees = new HashMap<>();
        edges = new HashMap<>();

        uiHandler = new Handler(Looper.getMainLooper());

        GsonBuilder builder = new GsonBuilder();

        builder.serializeNulls();

        gson = builder.create();

        if (ContextHelper.context == null) {
            ContextHelper.context = rootView.getContext();
        }

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

    public Edge getEdge(int edgeId) {
        return edges.get(edgeId);
    }

    public void addElementClass(String key, Class<? extends Element> elementClass) {
        elementClasses.put(key, elementClass);
    }

    public void addRequestClass(String key, Class<? extends Request> requestClass) {
        requestClasses.put(key, requestClass);
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

        String code = "window.Detonator.emit(\"" + name + "\", \"" + escape + "\");";

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

    @JavascriptInterface
    public void postMessage(String json) {
        /*

        why the uiHandler.post?

        the postMessage is executed on a background thread
        and the UI operations (like creating or modifying views)
        must occur on the UI thread

        if we don't use the uiHandler, the calls to mount, rerender, etc
        would happen on the background thread,
        causing crashes and undefined behavior

        */

        Message message = gson.fromJson(json, Message.class);

        uiHandler.post(() -> {
            switch (message.action) {
                case "treeInit": {
                    treeInit(message.data);

                    break;
                }

                case "treeDeinit": {
                    treeDeinit(message.data);

                    break;
                }

                case "mount": {
                    mount(message.data);

                    break;
                }

                case "rerender": {
                    rerender(message.data);

                    break;
                }

                case "unmount": {
                    unmount(message.data);

                    break;
                }

                case "style": {
                    style(message.data);

                    break;
                }

                case "request": {
                    request(message.data);

                    break;
                }

                case "log": {
                    log(message.data);

                    break;
                }
            }
        });
    }

    private void treeInit(String dataString) {
        TreeInitData data = gson.fromJson(dataString, TreeInitData.class);

        ViewLayout view;

        if (data.elementId != null) {
            Edge elementEdge = edges.get(data.elementId);

            view = (ViewLayout) elementEdge.element.view;
        } else {
            view = rootView;
        }

        Tree tree = new Tree(view);

        trees.put(data.treeId, tree);
    }

    private void treeDeinit(String dataString) {
        TreeDeinitData data = gson.fromJson(dataString, TreeDeinitData.class);

        trees.remove(data.treeId);
    }

    private void mount(String dataString) {
        MountData data = gson.fromJson(dataString, MountData.class);

        Tree tree = trees.get(data.treeId);

        Target target = new Target(tree.view, 0);

        tree.edge = data.edge;

        renderEdge(tree.edge, null, target);

        performLayout();
    }

    private void unmount(String dataString) {
        UnmountData data = gson.fromJson(dataString, UnmountData.class);

        Tree tree = trees.get(data.treeId);

        Target target = new Target(tree.view, 0);

        unmountEdge(tree.edge, target);

        tree.edge = null;

        performLayout();
    }

    private void rerender(String dataString) {
        RerenderData data = gson.fromJson(dataString, RerenderData.class);

        Tree tree = trees.get(data.treeId);

        for (Edge tmpEdge : data.edges) {
            Edge edge = edges.get(tmpEdge.id);

            Target target = createTarget(edge, tree);

            Edge prevEdge = edge.clone();

            edge.copyFrom(tmpEdge);

            renderEdge(edge, prevEdge, target);

            int difference = edge.targetViewsCount - prevEdge.targetViewsCount;

            if (difference != 0) {
                propagateTargetViewsCountDifference(edge, difference);
            }
        }

        performLayout();
    }

    private void style(String dataString) {
        StyleItem[] styleItems = gson.fromJson(dataString, StyleItem[].class);

        for (StyleItem styleItem : styleItems) {
            Edge edge = edges.get(styleItem.elementId);

            edge.element.applyStyle(styleItem.style, styleItem.keys);
        }

        performLayout();
    }

    private void request(String data) {
        Request.IncomingRequest incomingRequest = gson.fromJson(data, Request.IncomingRequest.class);

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

            request = constructor.newInstance(Detonator.this, incomingRequest);
        } catch (Exception e) {
            return;
        }

        request.run();
    }

    private void log(String dataString) {
        String str = dataString.substring(1, dataString.length() - 1);

        System.out.println(str);
    }

    public void performLayout() {
        rootView.performLayout();

        if (FullScreenModule.fullScreenView != null) {
            FullScreenModule.fullScreenView.performLayout();
        }
    }

    private void renderChildren(Edge edge, Edge prevEdge, Target target) {
        List<Edge> children = edge.children;

        List<Edge> prevChildren = prevEdge != null ? prevEdge.children : new ArrayList<>();

        for (Edge prevChild: prevChildren) {
            Edge child = null;

            for (Edge tmpChild : children) {
                if (prevChild.id == tmpChild.id) {
                    child = tmpChild;

                    break;
                }
            }

            if (child == null) {
                unmountEdge(prevChild, target);
            }
        }

        for (Edge child : children) {
            Edge prevChild = null;

            for (Edge tmpChild : prevChildren) {
                if (child.id == tmpChild.id) {
                    prevChild = tmpChild;

                    break;
                }
            }

            if (child.moved) {
                Target tmpTarget = new Target(target.view, target.index);

                moveEdge(prevChild, tmpTarget);
            }

            renderEdge(child, prevChild, target);
        }
    }

    private void renderEdge(Edge edge, Edge prevEdge, Target target) {
        edges.put(edge.id, edge);

        Element element = prevEdge != null ? prevEdge.element : null;

        if (element == null) {
            element = createElement(edge);

            if (element != null) {
                element.create();
            }
        }

        edge.element = element;

        if (element != null) {
            element.edge = edge;
        }

        if (edge.skipped) {
            target.index += prevEdge.targetViewsCount;

            edge.parent = prevEdge.parent;

            edge.contentType = prevEdge.contentType;

            edge.attributes = prevEdge.attributes;

            edge.children = prevEdge.children;

            edge.text = prevEdge.text;

            edge.targetViewsCount = prevEdge.targetViewsCount;

            return;
        }

        int initialTargetIndex = target.index;

        Target tmpTarget = target;

        if (element != null && element.view instanceof ViewGroup) {
            tmpTarget = new Target((ViewGroup) element.view, 0);
        }

        renderChildren(edge, prevEdge, tmpTarget);

        if (element != null) {
            /*
              In JavaScript, patch() is executed before renderChildren.
              However, here we need to execute it **after** because:

              - Elements like `TextElement` interact with their children inside `patchView()`.
              - Sometimes, child edges have a `null` `text` value (when they are skipped).
              - We rely on `renderChildren` to propagate the `text` from `prevEdge`.

              By running patch() after renderChildren, we ensure that all child elements
              have the correct `text` values before patching occurs.
            */

            element.patch();

            target.insert(element.view);
        }

        int targetViewsCount = target.index - initialTargetIndex;

        edge.targetViewsCount = targetViewsCount;
    }

    private void unmountEdge(Edge edge, Target target) {
        edges.remove(edge.id);

        Target tmpTarget = target;

        if (edge.element != null && target != null) {
            tmpTarget = null;
        }

        for (Edge child : edge.children) {
            unmountEdge(child, tmpTarget);
        }

        if (edge.element != null) {
            edge.element.remove();

            if (target != null) {
                target.remove(edge.element.view);
            }
        }
    }

    private Element createElement(Edge edge) {
        if (edge.contentType == null) {
            return null;
        }

        Class<? extends Element> elementClass = this.elementClasses.get(edge.contentType);

        if (elementClass == null) {
            return null;
        }

        try {
            Constructor<? extends Element> constructor;

            constructor = elementClass.getDeclaredConstructor(Detonator.class);

            return constructor.newInstance(this);
        } catch (Exception e) {
            return null;
        }
    }

    private Target createTarget(Edge edge, Tree tree) {
        return createTarget(edge, tree, 0);
    }

    private Target createTarget(Edge edge, Tree tree, int targetIndex) {
        if (edge.parent == null) {
            return new Target(tree.view, targetIndex);
        }

        Edge parent = edges.get(edge.parent);

        int index = parent.children.indexOf(edge);

        for (int i = index - 1; i >= 0; i--) {
            Edge child = parent.children.get(i);

            targetIndex += child.targetViewsCount;
        }

        if (parent.element != null) {
            return new Target((ViewLayout) parent.element.view, targetIndex);
        }

        return createTarget(parent, tree, targetIndex);
    }

    private void propagateTargetViewsCountDifference(Edge edge, int difference) {
        if (edge.parent == null) {
            return;
        }

        Edge parent = edges.get(edge.parent);

        Element element = parent.element;

        if (element != null) {
            return;
        }

        parent.targetViewsCount += difference;

        propagateTargetViewsCountDifference(parent, difference);
    }

    private void moveEdge(Edge edge, Target target) {
        if (edge.element != null) {
            target.insert(edge.element.view);

            return;
        }

        for (Edge child: edge.children) {
            moveEdge(child, target);
        }
    }

    private static class Message {
        String action;
        String data;
    }

    private static class TreeInitData {
        int treeId;
        Integer elementId;
    }

    private static class TreeDeinitData {
        int treeId;
    }

    private static class MountData {
        int treeId;
        Edge edge;
    }

    private static class UnmountData {
        int treeId;
    }

    private static class RerenderData {
        int treeId;
        Edge[] edges;
    }

    private static class StyleItem {
        int elementId;
        Style style;
        List<String> keys;
    }
}
