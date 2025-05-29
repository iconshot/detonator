package com.iconshot.detonator.renderer;

import android.view.ViewGroup;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.layout.ViewLayout;
import com.iconshot.detonator.module.fullscreen.FullScreenModule;

import java.lang.reflect.Constructor;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Renderer {
    private final Detonator detonator;

    private final ViewLayout rootView;

    public final Map<Integer, Tree> trees = new HashMap<>();
    public final Map<Integer, Edge> edges = new HashMap<>();

    public Renderer(Detonator detonator, ViewLayout rootView) {
        this.detonator = detonator;
        this.rootView = rootView;

        detonator.setMessageListener("com.iconshot.detonator.renderer::treeInit", value -> {
            TreeInitData data = detonator.decode(value, TreeInitData.class);

            ViewLayout view;

            if (data.elementId != null) {
                Edge elementEdge = edges.get(data.elementId);

                view = (ViewLayout) elementEdge.element.view;
            } else {
                view = rootView;
            }

            Tree tree = new Tree(view);

            trees.put(data.treeId, tree);
        });

        detonator.setMessageListener("com.iconshot.detonator.renderer::treeDeinit", value -> {
            TreeDeinitData data = detonator.decode(value, TreeDeinitData.class);

            trees.remove(data.treeId);
        });

        detonator.setMessageListener("com.iconshot.detonator.renderer::mount", value -> {
            MountData data = detonator.decode(value, MountData.class);

            Tree tree = trees.get(data.treeId);

            Target target = new Target(tree.view, 0);

            tree.edge = data.edge;

            renderEdge(tree.edge, null, target);

            performLayout();
        });

        detonator.setMessageListener("com.iconshot.detonator.renderer::unmount", value -> {
            UnmountData data = detonator.decode(value, UnmountData.class);

            Tree tree = trees.get(data.treeId);

            Target target = new Target(tree.view, 0);

            unmountEdge(tree.edge, target);

            tree.edge = null;

            performLayout();
        });

        detonator.setMessageListener("com.iconshot.detonator.renderer::rerender", value -> {
            RerenderData data = detonator.decode(value, RerenderData.class);

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
        });
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

        Class<? extends Element> elementClass = detonator.getElementClass(edge.contentType);

        if (elementClass == null) {
            return null;
        }

        try {
            Constructor<? extends Element> constructor;

            constructor = elementClass.getDeclaredConstructor(Detonator.class);

            return constructor.newInstance(detonator);
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

    public void performLayout() {
        rootView.performLayout();

        if (FullScreenModule.fullScreenView != null) {
            FullScreenModule.fullScreenView.performLayout();
        }
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
}
