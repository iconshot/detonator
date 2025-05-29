package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.InputElement;
import com.iconshot.detonator.renderer.Edge;

public class InputSetValueRequest extends Request<String> {
    public InputSetValueRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    @Override
    public void run() {
        String value = decodeData(String.class);

        Edge edge = getComponentEdge();

        InputElement element = (InputElement) edge.children.get(0).element;

        element.setValue(value);

        end();
    }
}
