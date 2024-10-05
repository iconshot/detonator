package com.iconshot.detonator.element;

import android.content.res.ColorStateList;
import android.widget.ProgressBar;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ColorHelper;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.PixelHelper;
import com.iconshot.detonator.layout.ViewLayout.LayoutParams;

public class ActivityIndicatorElement extends Element<ProgressBar, ActivityIndicatorElement.Attributes> {
    public ActivityIndicatorElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    protected Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    protected ProgressBar createView() {
        return new ProgressBar(ContextHelper.context);
    }

    @Override
    protected void patchView() {
        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        String size = attributes.size;

        String currentSize = currentAttributes != null ? currentAttributes.size : null;

        boolean patchSize = forcePatch || !CompareHelper.compareObjects(size, currentSize);

        if (patchSize) {
            String tmpSize = size != null ? size : "medium";

            int dp;

            switch (tmpSize) {
                default:
                case "medium": {
                    dp = 20;

                    break;
                }

                case "large": {
                    dp = 37;

                    break;
                }
            }

            int px = PixelHelper.dpToPx(dp);

            layoutParams.width = px;
            layoutParams.height = px;
        }
    }

    @Override
    protected void patchColor(Object color) {
        Integer tmpColor = ColorHelper.parseColor(color);

        view.setIndeterminateTintList(tmpColor != null ? ColorStateList.valueOf(tmpColor) : null);
    }

    public static class Attributes extends Element.Attributes {
        String size;
    }
}
