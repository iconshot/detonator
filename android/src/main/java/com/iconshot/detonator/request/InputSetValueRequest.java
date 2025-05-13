package com.iconshot.detonator.request;

import android.widget.EditText;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.renderer.Edge;

public class InputSetValueRequest extends Request<String> {
    public InputSetValueRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    @Override
    public void run() {
        String value = decodeData(String.class);

        Edge edge = getComponentEdge();

        Edge elementEdge = edge.children.get(0);

        EditText view = (EditText) elementEdge.element.view;

        view.setText(value);
    }
}
