package com.iconshot.detonator.element.scrollviewelement;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.layout.ViewLayout;

public class ScrollViewElement extends Element<CustomScrollView, ScrollViewElement.Attributes> {
    public ScrollViewElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    public CustomScrollView createView() {
        return new CustomScrollView(ContextHelper.context);
    }

    @Override
    protected void patchView() {
        Boolean showsIndicator = attributes.showsIndicator;

        Boolean currentShowsIndicator = currentAttributes != null ? currentAttributes.showsIndicator : null;

        boolean patchShowsIndicator = forcePatch || !CompareHelper.compareObjects(showsIndicator, currentShowsIndicator);

        if (patchShowsIndicator) {
            if (showsIndicator != null && showsIndicator) {
                view.setVerticalScrollBarEnabled(true);
            } else {
                view.setVerticalScrollBarEnabled(false);
            }
        }
    }

    protected void patchBackgroundColor(
            Object backgroundColor,
            Object borderRadius,
            Object borderRadiusTopLeft,
            Object borderRadiusTopRight,
            Object borderRadiusBottomLeft,
            Object borderRadiusBottomRight
    ) {
        super.patchBackgroundColor(
                backgroundColor,
                borderRadius,
                borderRadiusTopLeft,
                borderRadiusTopRight,
                borderRadiusBottomLeft,
                borderRadiusBottomRight
        );

        ViewLayout.LayoutParams layoutParams = (ViewLayout.LayoutParams) view.getLayoutParams();

        layoutParams.onLayoutClosures.put("borderRadius", () -> {
            float[] radii = getRadii(
                    borderRadius,
                    borderRadiusTopLeft,
                    borderRadiusTopRight,
                    borderRadiusBottomLeft,
                    borderRadiusBottomRight
            );

            view.setRadii(radii);
        });
    }

    protected static class Attributes extends Element.Attributes {
        Boolean horizontal;
        Boolean showsIndicator;
    }
}
