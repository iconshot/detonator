package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.InputElement;
import com.iconshot.detonator.renderer.Edge;

public class InputFocusRequest extends Request {
    public InputFocusRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        InputElement element = (InputElement) edge.children.get(0).element;

        element.focus(() -> end());
    }
}
