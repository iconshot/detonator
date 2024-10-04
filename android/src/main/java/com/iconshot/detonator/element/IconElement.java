package com.iconshot.detonator.element;

import android.graphics.Typeface;
import android.util.TypedValue;
import android.widget.TextView;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ColorHelper;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.IconHelper;
import com.iconshot.detonator.helpers.PixelHelper;

public class IconElement extends Element<TextView, IconElement.Attributes> {
    private int defaultColor;

    public IconElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
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
        String name = attributes.name;
        String currentName = currentAttributes != null ? currentAttributes.name : null;

        boolean patchName = forcePatch || !CompareHelper.compareObjects(name, currentName);

        if (patchName) {
            String font = IconHelper.getFont(name);

            if (font != null) {
                Typeface typeface = IconHelper.getTypeface(font);

                view.setTypeface(typeface);

                Character iconChar = IconHelper.getIcon(name);

                view.setText(iconChar != null ? String.valueOf(iconChar) : "");
            } else {
                view.setTypeface(null);
                view.setText("");
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

    static class Attributes extends Element.Attributes {
        String name;
    }
}
