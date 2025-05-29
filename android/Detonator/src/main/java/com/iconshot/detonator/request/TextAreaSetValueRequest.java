package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.TextAreaElement;
import com.iconshot.detonator.renderer.Edge;

public class TextAreaSetValueRequest extends Request<String> {
    public TextAreaSetValueRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    @Override
    public void run() {
        String value = decodeData(String.class);

        Edge edge = getComponentEdge();

        TextAreaElement element = (TextAreaElement) edge.children.get(0).element;

        element.setValue(value);

        end();
    }
}
