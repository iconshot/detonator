package com.iconshot.detonator.request;

import android.content.Context;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.TextView;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.tree.Edge;

public class TextAreaBlurRequest extends Request {
    public TextAreaBlurRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        Edge textEdge = edge.children.get(0);

        TextView view = (TextView) textEdge.element.view;

        view.clearFocus();

        view.post(() -> {
            InputMethodManager imm = (InputMethodManager) ContextHelper.context.getSystemService(Context.INPUT_METHOD_SERVICE);

            imm.hideSoftInputFromWindow(view.getWindowToken(), 0);

            end();
        });
    }
}
