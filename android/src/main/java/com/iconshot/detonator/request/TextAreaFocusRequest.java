package com.iconshot.detonator.request;

import android.content.Context;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.renderer.Edge;

public class TextAreaFocusRequest extends Request {
    public TextAreaFocusRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        Edge elementEdge = edge.children.get(0);

        EditText view = (EditText) elementEdge.element.view;

        view.requestFocus();

        view.post(() -> {
            InputMethodManager imm = (InputMethodManager) ContextHelper.context.getSystemService(Context.INPUT_METHOD_SERVICE);

            imm.showSoftInput(view, InputMethodManager.SHOW_IMPLICIT);

            end();
        });
    }
}
