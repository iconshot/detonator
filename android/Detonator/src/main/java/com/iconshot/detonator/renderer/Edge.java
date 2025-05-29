package com.iconshot.detonator.renderer;

import com.iconshot.detonator.element.Element;

import java.util.List;

public class Edge {
    public int id;
    public Integer parent;
    public String contentType;
    public String attributes;
    public List<Edge> children;
    public String text;
    public boolean skipped;
    public boolean moved;

    public Element element;

    public int targetViewsCount;

    public Edge clone() {
        Edge edge = new Edge();

        edge.copyFrom(this);

        return edge;
    }

    public void copyFrom(Edge edge) {
        id = edge.id;
        parent = edge.parent;
        contentType = edge.contentType;
        attributes = edge.attributes;
        children = edge.children;
        text = edge.text;
        skipped = edge.skipped;
        moved = edge.moved;
        element = edge.element;
        targetViewsCount = edge.targetViewsCount;
    }
}