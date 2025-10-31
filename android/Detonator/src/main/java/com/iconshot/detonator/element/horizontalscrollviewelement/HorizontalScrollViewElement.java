package com.iconshot.detonator.element.horizontalscrollviewelement;

import android.view.View;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.layout.ViewLayout;

public class HorizontalScrollViewElement extends Element<CustomHorizontalScrollView, HorizontalScrollViewElement.Attributes> {
    private boolean isAtRight = false;

    public HorizontalScrollViewElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    public CustomHorizontalScrollView createView() {
        CustomHorizontalScrollView view = new CustomHorizontalScrollView(detonator.context);

        view.setOnPageChangeListener(page -> {
            OnPageChangeData data = new OnPageChangeData();

            data.page = page;

            sendHandler("onPageChange", data);
        });

        view.getViewTreeObserver().addOnScrollChangedListener(() -> {
            View child = view.getChildAt(0);

            int diff = child.getRight() - (view.getWidth() + view.getScrollX());

            isAtRight = diff == 0;
        });

        return view;
    }

    @Override
    protected void patchView() {
        ViewLayout.LayoutParams layoutParams = (ViewLayout.LayoutParams) view.getLayoutParams();

        Boolean paginated = attributes.paginated;

        Boolean prevPaginated = prevAttributes != null ? prevAttributes.paginated : null;

        boolean patchPaginated = forcePatch || !CompareHelper.compareObjects(paginated, prevPaginated);

        if (patchPaginated) {
            boolean tmpPaginated = paginated != null ? paginated : false;

            view.setPaginated(tmpPaginated);
        }

        Boolean inverted = attributes.inverted;

        Boolean prevInverted = prevAttributes != null ? prevAttributes.inverted : null;

        boolean patchInverted = forcePatch || !CompareHelper.compareObjects(prevInverted, inverted);

        if (patchInverted) {
            boolean tmpInverted = inverted != null ? inverted : false;

            view.setInverted(tmpInverted);
        }

        Boolean showsIndicator = attributes.showsIndicator;

        Boolean prevShowsIndicator = prevAttributes != null ? prevAttributes.showsIndicator : null;

        boolean patchShowsIndicator = forcePatch || !CompareHelper.compareObjects(showsIndicator, prevShowsIndicator);

        if (patchShowsIndicator) {
            boolean value = showsIndicator != null && showsIndicator;

            view.setHorizontalScrollBarEnabled(value);
        }

        boolean scrollToRight = inverted != null && inverted && (forcePatch || isAtRight);

        if (scrollToRight) {
            layoutParams.onLayoutClosures.put("scroll", () -> {
                View child = view.getChildAt(0);

                view.scrollTo(child.getRight(), 0);
            });
        } else {
            layoutParams.onLayoutClosures.remove("scroll");
        }
    }

    @Override
    protected void patchPadding(
            Float padding,
            Float paddingHorizontal,
            Float paddingVertical,
            Float paddingTop,
            Float paddingLeft,
            Float paddingBottom,
            Float paddingRight
    ) {
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

    private static class OnPageChangeData {
        int page;
    }

    protected static class Attributes extends Element.Attributes {
        Boolean horizontal;
        Boolean paginated;
        Boolean inverted;
        Boolean showsIndicator;
        Boolean onPageChange;
    }
}
