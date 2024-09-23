package com.iconshot.detonator.element.viewelement;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.layout.ViewLayout;
import com.iconshot.detonator.layout.ViewLayout.LayoutParams;

public abstract class BaseViewElement<T extends BaseViewElement.Attributes> extends Element<ViewLayout, T> {
    public BaseViewElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public ViewLayout createView() {
        return new ViewLayout(ContextHelper.context);
    }

    @Override
    protected void patchView() {}

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

        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

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

    protected void patchOverflow(String overflow) {
        String tmpOverflow = overflow != null ? overflow : "visible";

        switch (tmpOverflow) {
            case "visible":
            default: {
                view.setOverflow(ViewLayout.OVERFLOW_VISIBLE);

                break;
            }

            case "hidden": {
                view.setOverflow(ViewLayout.OVERFLOW_HIDDEN);
            }
        }
    }

    protected void patchFlexDirection(String flexDirection) {
        int tmpFlexDirection = LayoutParams.FLEX_DIRECTION_COLUMN;

        if (flexDirection != null) {
            switch (flexDirection) {
                case "row": {
                    tmpFlexDirection = LayoutParams.FLEX_DIRECTION_ROW;

                    break;
                }

                case "row-reverse": {
                    tmpFlexDirection = LayoutParams.FLEX_DIRECTION_ROW_REVERSE;

                    break;
                }

                case "column-reverse": {
                    tmpFlexDirection = LayoutParams.FLEX_DIRECTION_COLUMN_REVERSE;

                    break;
                }
            }
        }

        view.setFlexDirection(tmpFlexDirection);
    }

    protected void patchJustifyContent(String justifyContent) {
        int tmpJustifyContent = LayoutParams.JUSTIFY_CONTENT_FLEX_START;

        if (justifyContent != null) {
            switch (justifyContent) {
                case "flex-end": {
                    tmpJustifyContent = LayoutParams.JUSTIFY_CONTENT_FLEX_END;

                    break;
                }

                case "start": {
                    tmpJustifyContent = LayoutParams.JUSTIFY_CONTENT_START;

                    break;
                }

                case "end": {
                    tmpJustifyContent = LayoutParams.JUSTIFY_CONTENT_END;

                    break;
                }

                case "center": {
                    tmpJustifyContent = LayoutParams.JUSTIFY_CONTENT_CENTER;

                    break;
                }

                case "space-between": {
                    tmpJustifyContent = LayoutParams.JUSTIFY_CONTENT_SPACE_BETWEEN;

                    break;
                }

                case "space-around": {
                    tmpJustifyContent = LayoutParams.JUSTIFY_CONTENT_SPACE_AROUND;

                    break;
                }

                case "space-evenly": {
                    tmpJustifyContent = LayoutParams.JUSTIFY_CONTENT_SPACE_EVENLY;

                    break;
                }
            }
        }

        view.setJustifyContent(tmpJustifyContent);
    }

    protected void patchAlignItems(String alignItems) {
        int tmpAlignItems = LayoutParams.ALIGN_ITEMS_FLEX_START;

        if (alignItems != null) {
            switch (alignItems) {
                case "flex-end": {
                    tmpAlignItems = LayoutParams.ALIGN_ITEMS_FLEX_END;

                    break;
                }

                case "start": {
                    tmpAlignItems = LayoutParams.ALIGN_ITEMS_START;

                    break;
                }

                case "end": {
                    tmpAlignItems = LayoutParams.ALIGN_ITEMS_END;

                    break;
                }

                case "center": {
                    tmpAlignItems = LayoutParams.ALIGN_ITEMS_CENTER;

                    break;
                }
            }
        }

        view.setAlignItems(tmpAlignItems);
    }

    public static class Attributes extends Element.Attributes {
    }
}
