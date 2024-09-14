package com.iconshot.detonator;

import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.element.imageelement.ImageElement;
import com.iconshot.detonator.element.InputElement;
import com.iconshot.detonator.element.TextAreaElement;
import com.iconshot.detonator.element.TextElement;
import com.iconshot.detonator.element.videoelement.VideoElement;
import com.iconshot.detonator.element.ViewElement;
import com.iconshot.detonator.element.Style;

import com.iconshot.detonator.emitter.EventEmitter;
import com.iconshot.detonator.emitter.HandlerEmitter;

import com.iconshot.detonator.request.Request;
import com.iconshot.detonator.request.InputBlurRequest;
import com.iconshot.detonator.request.InputFocusRequest;
import com.iconshot.detonator.request.ImageGetSizeRequest;
import com.iconshot.detonator.request.TextAreaBlurRequest;
import com.iconshot.detonator.request.TextAreaFocusRequest;
import com.iconshot.detonator.request.ToastShowRequest;
import com.iconshot.detonator.request.VideoPauseRequest;
import com.iconshot.detonator.request.VideoPlayRequest;
import com.iconshot.detonator.request.VideoSeekRequest;

import com.iconshot.detonator.module.Module;
import com.iconshot.detonator.module.AppStateModule;
import com.iconshot.detonator.module.StorageModule;

import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.FileHelper;

import com.iconshot.detonator.layout.ViewLayout;

import com.iconshot.detonator.tree.Tree;
import com.iconshot.detonator.tree.Edge;
import com.iconshot.detonator.tree.Target;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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

public class Detonator {
    private final String path;
    private final Map<String, Class<? extends Element>> elementClasses;
    private final Map<String, Class<? extends Request>> requestClasses;
    private final Map<String, Class<? extends Module>> moduleClasses;
    private final Map<String, Module> modules;
    public final HandlerEmitter handlerEmitter;
    public final EventEmitter eventEmitter;
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

        addRequestClass("com.iconshot.detonator.input/focus", InputFocusRequest.class);
        addRequestClass("com.iconshot.detonator.input/blur", InputBlurRequest.class);
        addRequestClass("com.iconshot.detonator.textarea/focus", TextAreaFocusRequest.class);
        addRequestClass("com.iconshot.detonator.textarea/blur", TextAreaBlurRequest.class);
        addRequestClass("com.iconshot.detonator.image/getSize", ImageGetSizeRequest.class);
        addRequestClass("com.iconshot.detonator.video/play", VideoPlayRequest.class);
        addRequestClass("com.iconshot.detonator.video/pause", VideoPauseRequest.class);
        addRequestClass("com.iconshot.detonator.video/seek", VideoSeekRequest.class);
        addRequestClass("com.iconshot.detonator.toast/show", ToastShowRequest.class);

        addModuleClass("com.iconshot.detonator.appstate", AppStateModule.class);
        addModuleClass("com.iconshot.detonator.storage", StorageModule.class);

        initWebView();

        registerModules();
    }

    private void initWebView() {
        webView = new WebView(ContextHelper.context);

        webView.getSettings().setJavaScriptEnabled(true);

        webView.addJavascriptInterface(this, "Detonator");

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

        String code = "window.emitter.emit(\"" + name + "\", \"" + escape + "\");";

        evaluate(code);
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

            ViewLayout view = findTargetView(edge);

            if (view == null) {
                view = tree.view;
            }

            int index = findTargetIndex(edge, view);

            Target target = new Target(view, index);

            Edge currentEdge = edge.clone();

            edge.copyFrom(tmpEdge);

            renderEdge(edge, currentEdge, target);
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
        System.out.println(dataString);
    }

    public void performLayout() {
        rootView.performLayout();
    }

    private void renderEdge(Edge edge, Edge currentEdge, Target target) {
        Element element = currentEdge != null ? currentEdge.element : null;

        if (element == null) {
            element = createElement(edge);

            if (element != null) {
                element.create();
            }
        }

        if (element != null) {
            element.edge = edge;
            element.currentEdge = currentEdge;
        }

        Target tmpTarget = target;

        if (element != null) {
            element.patch();

            if (element.view instanceof ViewLayout) {
                tmpTarget = new Target((ViewLayout) element.view, 0);
            }
        }

        edge.element = element;

        renderChildren(edge, currentEdge, tmpTarget);

        if (element != null) {
            target.insert(element.view);
        }

        edges.put(edge.id, edge);
    }

    private void renderChildren(Edge edge, Edge currentEdge, Target target) {
        List<Edge> children = edge.children;

        List<Edge> currentChildren = currentEdge != null ? currentEdge.children : new ArrayList<>();

        for (Edge currentChild: currentChildren) {
            Edge child = null;

            for (Edge tmpChild : children) {
                if (currentChild.id == tmpChild.id) {
                    child = tmpChild;

                    break;
                }
            }

            if (child == null) {
                unmountEdge(currentChild, target);
            }
        }

        for (Edge child : children) {
            Edge currentChild = null;

            for (Edge tmpChild : currentChildren) {
                if (child.id == tmpChild.id) {
                    currentChild = tmpChild;

                    break;
                }
            }

            renderEdge(child, currentChild, target);
        }
    }

    private void unmountEdge(Edge edge, Target target) {
        Target tmpTarget = target;

        if (edge.element != null && target != null) {
            target.remove(edge.element.view);

            tmpTarget = null;
        }

        for (Edge child : edge.children) {
            unmountEdge(child, tmpTarget);
        }

        edges.remove(edge.id);
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

    private ViewLayout findTargetView(Edge edge) {
        Edge parent = edge.parent != null ? edges.get(edge.parent) : null;

        if (parent == null) {
            return null;
        }

        if (parent.element != null) {
            return (ViewLayout) parent.element.view;
        }

        return findTargetView(parent);
    }

    private int findTargetIndex(Edge edge, ViewLayout targetView) {
        Edge parent = edge.parent != null ? edges.get(edge.parent) : null;

        if (parent == null) {
            return 0;
        }

        int index = parent.children.indexOf(edge);

        for (int i = index - 1; i >= 0; i--) {
            Edge child = parent.children.get(i);

            Integer j = findViewIndex(child, targetView);

            if (j != null) {
                return j + 1;
            }
        }

        if (parent.element != null && parent.element.view == targetView) {
            return 0;
        }

        return findTargetIndex(parent, targetView);
    }

    private Integer findViewIndex(Edge edge, ViewLayout targetView) {
        if (edge.element != null) {
            return targetView.indexOfChild(edge.element.view);
        }

        for (int i = edge.children.size() - 1; i >= 0; i--) {
            Edge child = edge.children.get(i);

            Integer index = findViewIndex(child, targetView);

            if (index != null) {
                return index;
            }
        }

        return null;
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
