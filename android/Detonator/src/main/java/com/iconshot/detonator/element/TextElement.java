package com.iconshot.detonator.element;

import android.util.TypedValue;
import android.widget.TextView;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ColorHelper;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.PixelHelper;
import com.iconshot.detonator.tree.Edge;

public class TextElement extends Element<TextView, TextElement.Attributes> {
    private int defaultColor;

    public TextElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    protected Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    protected TextView createView() {
        TextView view = new TextView(ContextHelper.context);

        defaultColor = view.getCurrentTextColor();

        return view;
    }

    @Override
    protected void patchView() {
        if (!edge.children.isEmpty()) {
            StringBuilder stringBuilder = new StringBuilder();

            for (Edge child : edge.children) {
                if (child.text != null) {
                    stringBuilder.append(child.text);
                }
            }

            String text = stringBuilder.toString();

            if (!view.getText().equals(text)) {
                view.setText(text);
            }
        }
    }

    protected void patchFontSize(Float fontSize) {
        float value = ((Integer) PixelHelper.dpToPx(fontSize != null ? fontSize : 16)).floatValue();

        view.setTextSize(TypedValue.COMPLEX_UNIT_PX, value);
    }

    protected void patchColor(Object color) {
        Integer tmpColor = ColorHelper.parseColor(color);

        view.setTextColor(tmpColor != null ? tmpColor : defaultColor);
    }

    protected static class Attributes extends Element.Attributes {}
}
