package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.InputElement;
import com.iconshot.detonator.renderer.Edge;

public class InputBlurRequest extends Request {
    public InputBlurRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        InputElement element = (InputElement) edge.children.get(0).element;

        element.blur(() -> end());
    }
}
