package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.TextAreaElement;
import com.iconshot.detonator.renderer.Edge;

public class TextAreaBlurRequest extends Request {
    public TextAreaBlurRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        TextAreaElement element = (TextAreaElement) edge.children.get(0).element;

        element.blur(() -> end());
    }
}
