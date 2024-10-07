package com.iconshot.detonator.element.horizontalscrollviewelement;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.layout.ViewLayout;

public class HorizontalScrollViewElement extends Element<CustomHorizontalScrollView, HorizontalScrollViewElement.Attributes> {
    public HorizontalScrollViewElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    public CustomHorizontalScrollView createView() {
        CustomHorizontalScrollView view = new CustomHorizontalScrollView(ContextHelper.context);

        view.setOnPageChangeListener(page -> {
            OnPageChangeData data = new OnPageChangeData();

            data.page = page;

            detonator.emitHandler("onPageChange", edge.id, data);
        });

        return view;
    }

    @Override
    protected void patchView() {
        Boolean paginated = attributes.paginated;

        Boolean currentPaginated = currentAttributes != null ? currentAttributes.paginated : null;

        boolean patchPaginated = forcePatch || !CompareHelper.compareObjects(paginated, currentPaginated);

        if (patchPaginated) {
            boolean tmpPaginated = paginated != null ? paginated : false;

            view.setPaginated(tmpPaginated);
        }

        Boolean showsIndicator = attributes.showsIndicator;

        Boolean currentShowsIndicator = currentAttributes != null ? currentAttributes.showsIndicator : null;

        boolean patchShowsIndicator = forcePatch || !CompareHelper.compareObjects(showsIndicator, currentShowsIndicator);

        if (patchShowsIndicator) {
            boolean value = showsIndicator != null && showsIndicator;

            view.setHorizontalScrollBarEnabled(value);
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

    private static class OnPageChangeData {
        int page;
    }

    protected static class Attributes extends Element.Attributes {
        Boolean horizontal;
        Boolean paginated;
        Boolean showsIndicator;
        Boolean onPageChange;
    }
}
