package com.iconshot.detonator.layout;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.RectF;
import android.view.View;
import android.view.ViewGroup;
import android.util.AttributeSet;
import android.widget.TextView;

import java.util.HashMap;
import java.util.Map;

public class ViewLayout extends ViewGroup {
    public static int ID = 0;

    public int id = 0;

    public static int OVERFLOW_VISIBLE = 0;
    public static int OVERFLOW_HIDDEN = 1;

    public boolean remeasured = false;

    private int overflow = OVERFLOW_VISIBLE;

    private int flexDirection = LayoutParams.FLEX_DIRECTION_COLUMN;

    private int justifyContent = LayoutParams.JUSTIFY_CONTENT_FLEX_START;
    private int alignItems = LayoutParams.ALIGN_ITEMS_FLEX_START;

    private float[] radii;

    private final RectF rect = new RectF(0, 0, 0, 0);

    private final Path path = new Path();

    public ViewLayout(Context context) {
        super(context);

        init();
    }

    public ViewLayout(Context context, AttributeSet attrs) {
        super(context, attrs);

        init();
    }

    public ViewLayout(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);

        init();
    }

    @Override
    protected LayoutParams generateLayoutParams(ViewGroup.LayoutParams p) {
        return new LayoutParams(p);
    }

    @Override
    public LayoutParams generateLayoutParams(AttributeSet attrs) {
        return new LayoutParams(getContext(), attrs);
    }

    @Override
    protected LayoutParams generateDefaultLayoutParams() {
        return new LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
    }

    @Override
    protected boolean checkLayoutParams(ViewGroup.LayoutParams p) {
        return p instanceof LayoutParams;
    }

    private void init() {
        id = ViewLayout.ID++;

        setClipChildren(false);
        setClipToPadding(false);
    }

    public void setOverflow(int overflow) {
        if (this.overflow == overflow) {
            return;
        }

        this.overflow = overflow;

        invalidate();
    }

    public void setFlexDirection(int flexDirection) {
        if (this.flexDirection == flexDirection) {
            return;
        }

        this.flexDirection = flexDirection;

        requestLayout();
    }

    public void setJustifyContent(int justifyContent) {
        if (this.justifyContent == justifyContent) {
            return;
        }

        this.justifyContent = justifyContent;

        requestLayout();
    }

    public void setAlignItems(int alignItems) {
        if (this.alignItems == alignItems) {
            return;
        }

        this.alignItems = alignItems;

        requestLayout();
    }

    public void setRadii(float[] radii) {
        this.radii = radii;

        this.invalidate();
    }

    private boolean isHorizontal() {
        return flexDirection == LayoutParams.FLEX_DIRECTION_ROW || flexDirection == LayoutParams.FLEX_DIRECTION_ROW_REVERSE;
    }

    private boolean isReversed() {
        return flexDirection == LayoutParams.FLEX_DIRECTION_ROW_REVERSE || flexDirection == LayoutParams.FLEX_DIRECTION_COLUMN_REVERSE;
    }

    public void performLayout() {
        requestLayout();
    }

    @Override
    protected void onMeasure(int widthSpec, int heightSpec) {
        // System.out.println("onMeasure " + id);

        int specWidth = MeasureSpec.getSize(widthSpec);
        int specHeight = MeasureSpec.getSize(heightSpec);

        int specWidthMode = MeasureSpec.getMode(widthSpec);
        int specHeightMode = MeasureSpec.getMode(heightSpec);

        boolean isRemeasured = false;

        isRemeasured |= remeasured;

        boolean isParentViewLayout = getParent() instanceof ViewLayout;

        if (isParentViewLayout) {
            LayoutParams layoutParams = (LayoutParams) getLayoutParams();

            isRemeasured |= layoutParams.remeasured;
        }

        if (isRemeasured) {
            setMeasuredDimension(specWidth, specHeight);

            onMeasureAbsoluteChildren();

            return;
        }

        int paddingTop = getPaddingTop();
        int paddingLeft = getPaddingLeft();
        int paddingBottom = getPaddingBottom();
        int paddingRight = getPaddingRight();

        int paddingX = paddingLeft + paddingRight;
        int paddingY = paddingTop + paddingBottom;

        int innerWidth = specWidth - paddingX;
        int innerHeight = specHeight - paddingY;

        int contentWidth = 0;
        int contentHeight = 0;

        boolean canItemsExpand = isHorizontal()
                ? specWidthMode != MeasureSpec.UNSPECIFIED
                : specHeightMode != MeasureSpec.UNSPECIFIED;

        int availableSize = isHorizontal() ? innerWidth : innerHeight;

        int flexCount = 0;
        int totalFlex = 0;

        // measure relative non-flex non-expandable items and gather totalFlex

        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);

            LayoutParams layoutParams = (LayoutParams) child.getLayoutParams();

            boolean isHidden = layoutParams.display == LayoutParams.DISPLAY_NONE;
            boolean isAbsolute = layoutParams.position == LayoutParams.POSITION_ABSOLUTE;

            if (isHidden) {
                continue;
            }

            if (isAbsolute) {
                continue;
            }

            int marginTop = layoutParams.topMargin;
            int marginLeft = layoutParams.leftMargin;
            int marginBottom = layoutParams.bottomMargin;
            int marginRight = layoutParams.rightMargin;

            int marginX = marginLeft + marginRight;
            int marginY = marginTop + marginBottom;

            availableSize -= isHorizontal() ? marginX : marginY;

            boolean hasFlex = layoutParams.flex != null;

            boolean useFlex = hasFlex && canItemsExpand;

            if (useFlex) {
                flexCount++;

                totalFlex += layoutParams.flex;

                continue;
            }

            boolean hasWidth = layoutParams.width >= 0 || layoutParams.widthPercent != null;
            boolean hasHeight = layoutParams.height >= 0 || layoutParams.heightPercent != null;

            boolean hasMinWidth = layoutParams.minWidth != null || layoutParams.minWidthPercent != null;
            boolean hasMinHeight = layoutParams.minHeight != null || layoutParams.minHeightPercent != null;

            boolean hasMaxWidth = layoutParams.maxWidth != null || layoutParams.maxWidthPercent != null;
            boolean hasMaxHeight = layoutParams.maxHeight != null || layoutParams.maxHeightPercent != null;

            boolean useWidth = hasWidth && (layoutParams.widthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useHeight = hasHeight && (layoutParams.heightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            boolean useMinWidth = hasMinWidth && (layoutParams.minWidthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useMinHeight = hasMinHeight && (layoutParams.minHeightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            boolean useMaxWidth = hasMaxWidth && (layoutParams.maxWidthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useMaxHeight = hasMaxHeight && (layoutParams.maxHeightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            if (isHorizontal()) {
                if (!useWidth) {
                    continue;
                }
            } else {
                if (!useHeight) {
                    continue;
                }
            }

            int childWidthSpec = specWidthMode != MeasureSpec.UNSPECIFIED
                    ? MeasureSpec.makeMeasureSpec(innerWidth, MeasureSpec.AT_MOST)
                    : MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

            int childHeightSpec = specHeightMode != MeasureSpec.UNSPECIFIED
                    ? MeasureSpec.makeMeasureSpec(innerHeight, MeasureSpec.AT_MOST)
                    : MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

            if (useWidth) {
                int width = layoutParams.width >= 0
                        ? layoutParams.width
                        : (int) (innerWidth * layoutParams.widthPercent);

                if (useMaxWidth) {
                    int maxWidth = layoutParams.maxWidth != null
                            ? layoutParams.maxWidth
                            : (int) (innerWidth * layoutParams.maxWidthPercent);

                    width = Math.min(width, maxWidth);
                }

                if (useMinWidth) {
                    int minWidth = layoutParams.minWidth != null
                            ? layoutParams.minWidth
                            : (int) (innerWidth * layoutParams.minWidthPercent);

                    width = Math.max(width, minWidth);
                }

                childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
            } else {
                if (useMaxWidth) {
                    int maxWidth = layoutParams.maxWidth != null
                            ? layoutParams.maxWidth
                            : (int) (innerWidth * layoutParams.maxWidthPercent);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(maxWidth, MeasureSpec.AT_MOST);
                }
            }

            if (useHeight) {
                int height = layoutParams.height >= 0
                        ? layoutParams.height
                        : (int) (innerHeight * layoutParams.heightPercent);

                if (useMaxHeight) {
                    int maxHeight = layoutParams.maxHeight != null
                            ? layoutParams.maxHeight
                            : (int) (innerHeight * layoutParams.maxHeightPercent);

                    height = Math.min(height, maxHeight);
                }

                if (useMinHeight) {
                    int minHeight = layoutParams.minHeight != null
                            ? layoutParams.minHeight
                            : (int) (innerHeight * layoutParams.minHeightPercent);

                    height = Math.max(height, minHeight);
                }

                childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
            } else {
                if (useMaxHeight) {
                    int maxHeight = layoutParams.maxHeight != null
                            ? layoutParams.maxHeight
                            : (int) (innerHeight * layoutParams.maxHeightPercent);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(maxHeight, MeasureSpec.AT_MOST);
                }
            }

            if (layoutParams.aspectRatio != null) {
                if (useWidth) {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                } else if (useHeight) {
                    int width = (int) (MeasureSpec.getSize(childHeightSpec) * layoutParams.aspectRatio);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                }
            }

            forceChildMeasure(child, childWidthSpec, childHeightSpec);

            childWidthSpec = MeasureSpec.makeMeasureSpec(child.getMeasuredWidth(), MeasureSpec.EXACTLY);
            childHeightSpec = MeasureSpec.makeMeasureSpec(child.getMeasuredHeight(), MeasureSpec.EXACTLY);

            if (!useWidth) {
                int width = MeasureSpec.getSize(childWidthSpec);

                if (useMinWidth) {
                    int minWidth = layoutParams.minWidth != null
                            ? layoutParams.minWidth
                            : (int) (innerWidth * layoutParams.minWidthPercent);

                    width = Math.max(width, minWidth);
                }

                childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
            }

            if (!useHeight) {
                int height = MeasureSpec.getSize(childHeightSpec);

                if (useMinHeight) {
                    int minHeight = layoutParams.minHeight != null
                            ? layoutParams.minHeight
                            : (int) (innerHeight * layoutParams.minHeightPercent);

                    height = Math.max(height, minHeight);
                }

                childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
            }

            if (layoutParams.aspectRatio != null && !useWidth && !useHeight) {
                boolean hasAnyWidth = hasWidth || hasMinWidth || hasMaxWidth;
                boolean hasAnyHeight = hasHeight || hasMinHeight || hasMaxHeight;

                if (hasAnyWidth) {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                } else if (hasAnyHeight) {
                    int width = (int) (MeasureSpec.getSize(childHeightSpec) * layoutParams.aspectRatio);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                } else {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                }
            }

            remeasureChild(child, childWidthSpec, childHeightSpec);

            int childWidth = child.getMeasuredWidth();
            int childHeight = child.getMeasuredHeight();

            availableSize -= isHorizontal() ? childWidth : childHeight;
        }

        // measure relative expandable items

        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);

            LayoutParams layoutParams = (LayoutParams) child.getLayoutParams();

            boolean isHidden = layoutParams.display == LayoutParams.DISPLAY_NONE;
            boolean isAbsolute = layoutParams.position == LayoutParams.POSITION_ABSOLUTE;

            if (isHidden) {
                continue;
            }

            if (isAbsolute) {
                continue;
            }

            boolean hasFlex = layoutParams.flex != null;

            boolean useFlex = hasFlex && canItemsExpand;

            if (useFlex) {
                continue;
            }

            boolean hasWidth = layoutParams.width >= 0 || layoutParams.widthPercent != null;
            boolean hasHeight = layoutParams.height >= 0 || layoutParams.heightPercent != null;

            boolean hasMinWidth = layoutParams.minWidth != null || layoutParams.minWidthPercent != null;
            boolean hasMinHeight = layoutParams.minHeight != null || layoutParams.minHeightPercent != null;

            boolean hasMaxWidth = layoutParams.maxWidth != null || layoutParams.maxWidthPercent != null;
            boolean hasMaxHeight = layoutParams.maxHeight != null || layoutParams.maxHeightPercent != null;

            boolean useWidth = hasWidth && (layoutParams.widthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useHeight = hasHeight && (layoutParams.heightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            boolean useMinWidth = hasMinWidth && (layoutParams.minWidthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useMinHeight = hasMinHeight && (layoutParams.minHeightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            boolean useMaxWidth = hasMaxWidth && (layoutParams.maxWidthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useMaxHeight = hasMaxHeight && (layoutParams.maxHeightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            if (isHorizontal()) {
                if (useWidth) {
                    continue;
                }
            } else {
                if (useHeight) {
                    continue;
                }
            }

            int childWidthSpec = specWidthMode != MeasureSpec.UNSPECIFIED
                    ? MeasureSpec.makeMeasureSpec(isHorizontal() ? availableSize : innerWidth, MeasureSpec.AT_MOST)
                    : MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

            int childHeightSpec = specHeightMode != MeasureSpec.UNSPECIFIED
                    ? MeasureSpec.makeMeasureSpec(!isHorizontal() ? availableSize : innerHeight, MeasureSpec.AT_MOST)
                    : MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

            if (useWidth) {
                int width = layoutParams.width >= 0
                        ? layoutParams.width
                        : (int) (innerWidth * layoutParams.widthPercent);

                if (useMaxWidth) {
                    int maxWidth = layoutParams.maxWidth != null
                            ? layoutParams.maxWidth
                            : (int) (innerWidth * layoutParams.maxWidthPercent);

                    width = Math.min(width, maxWidth);
                }

                if (useMinWidth) {
                    int minWidth = layoutParams.minWidth != null
                            ? layoutParams.minWidth
                            : (int) (innerWidth * layoutParams.minWidthPercent);

                    width = Math.max(width, minWidth);
                }

                childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
            } else {
                if (useMaxWidth) {
                    int maxWidth = layoutParams.maxWidth != null
                            ? layoutParams.maxWidth
                            : (int) (innerWidth * layoutParams.maxWidthPercent);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(maxWidth, MeasureSpec.AT_MOST);
                }
            }

            if (useHeight) {
                int height = layoutParams.height >= 0
                        ? layoutParams.height
                        : (int) (innerHeight * layoutParams.heightPercent);

                if (useMaxHeight) {
                    int maxHeight = layoutParams.maxHeight != null
                            ? layoutParams.maxHeight
                            : (int) (innerHeight * layoutParams.maxHeightPercent);

                    height = Math.min(height, maxHeight);
                }

                if (useMinHeight) {
                    int minHeight = layoutParams.minHeight != null
                            ? layoutParams.minHeight
                            : (int) (innerHeight * layoutParams.minHeightPercent);

                    height = Math.max(height, minHeight);
                }

                childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
            } else {
                if (useMaxHeight) {
                    int maxHeight = layoutParams.maxHeight != null
                            ? layoutParams.maxHeight
                            : (int) (innerHeight * layoutParams.maxHeightPercent);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(maxHeight, MeasureSpec.AT_MOST);
                }
            }

            if (layoutParams.aspectRatio != null) {
                if (useWidth) {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                } else if (useHeight) {
                    int width = (int) (MeasureSpec.getSize(childHeightSpec) * layoutParams.aspectRatio);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                }
            }

            forceChildMeasure(child, childWidthSpec, childHeightSpec);

            childWidthSpec = MeasureSpec.makeMeasureSpec(child.getMeasuredWidth(), MeasureSpec.EXACTLY);
            childHeightSpec = MeasureSpec.makeMeasureSpec(child.getMeasuredHeight(), MeasureSpec.EXACTLY);

            if (!useWidth) {
                int width = MeasureSpec.getSize(childWidthSpec);

                if (useMinWidth) {
                    int minWidth = layoutParams.minWidth != null
                            ? layoutParams.minWidth
                            : (int) (innerWidth * layoutParams.minWidthPercent);

                    width = Math.max(width, minWidth);
                }

                childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
            }

            if (!useHeight) {
                int height = MeasureSpec.getSize(childHeightSpec);

                if (useMinHeight) {
                    int minHeight = layoutParams.minHeight != null
                            ? layoutParams.minHeight
                            : (int) (innerHeight * layoutParams.minHeightPercent);

                    height = Math.max(height, minHeight);
                }

                childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
            }

            if (layoutParams.aspectRatio != null && !useWidth && !useHeight) {
                boolean hasAnyWidth = hasWidth || hasMinWidth || hasMaxWidth;
                boolean hasAnyHeight = hasHeight || hasMinHeight || hasMaxHeight;

                if (hasAnyWidth) {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                } else if (hasAnyHeight) {
                    int width = (int) (MeasureSpec.getSize(childHeightSpec) * layoutParams.aspectRatio);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                } else {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                }
            }

            remeasureChild(child, childWidthSpec, childHeightSpec);

            int childWidth = child.getMeasuredWidth();
            int childHeight = child.getMeasuredHeight();

            availableSize -= isHorizontal() ? childWidth : childHeight;
        }

        // calculate flex values

        int flexBaseSize = 0;
        int flexDistribution = 0;
        int flexRemainder = 0;

        if (flexCount > 0) {
            flexBaseSize = availableSize / totalFlex;

            int baseFlexRemainder = availableSize % totalFlex;

            flexDistribution = baseFlexRemainder / flexCount;

            flexRemainder = baseFlexRemainder % flexCount;
        }

        // measure flex items

        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);

            LayoutParams layoutParams = (LayoutParams) child.getLayoutParams();

            boolean isHidden = layoutParams.display == LayoutParams.DISPLAY_NONE;
            boolean isAbsolute = layoutParams.position == LayoutParams.POSITION_ABSOLUTE;

            if (isHidden) {
                continue;
            }

            if (isAbsolute) {
                continue;
            }

            boolean hasFlex = layoutParams.flex != null;

            boolean useFlex = hasFlex && canItemsExpand;

            if (!useFlex) {
                continue;
            }

            int flexSize = flexBaseSize * layoutParams.flex + flexDistribution;

            if (flexRemainder > 0) {
                flexSize++;

                flexRemainder--;
            }

            int childWidthSpec = specWidthMode != MeasureSpec.UNSPECIFIED
                    ? MeasureSpec.makeMeasureSpec(innerWidth, MeasureSpec.AT_MOST)
                    : MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

            int childHeightSpec = specHeightMode != MeasureSpec.UNSPECIFIED
                    ? MeasureSpec.makeMeasureSpec(innerHeight, MeasureSpec.AT_MOST)
                    : MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

            boolean hasWidth = layoutParams.width >= 0 || layoutParams.widthPercent != null;
            boolean hasHeight = layoutParams.height >= 0 || layoutParams.heightPercent != null;

            boolean hasMinWidth = layoutParams.minWidth != null || layoutParams.minWidthPercent != null;
            boolean hasMinHeight = layoutParams.minHeight != null || layoutParams.minHeightPercent != null;

            boolean hasMaxWidth = layoutParams.maxWidth != null || layoutParams.maxWidthPercent != null;
            boolean hasMaxHeight = layoutParams.maxHeight != null || layoutParams.maxHeightPercent != null;

            boolean useWidth = hasWidth && (layoutParams.widthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useHeight = hasHeight && (layoutParams.heightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            boolean useMinWidth = hasMinWidth && (layoutParams.minWidthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useMinHeight = hasMinHeight && (layoutParams.minHeightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            boolean useMaxWidth = hasMaxWidth && (layoutParams.maxWidthPercent == null || specWidthMode != MeasureSpec.UNSPECIFIED);
            boolean useMaxHeight = hasMaxHeight && (layoutParams.maxHeightPercent == null || specHeightMode != MeasureSpec.UNSPECIFIED);

            int flexSpec = MeasureSpec.makeMeasureSpec(flexSize, MeasureSpec.EXACTLY);

            if (isHorizontal()) {
                childWidthSpec = flexSpec;

                if (useHeight) {
                    int height = layoutParams.height >= 0
                            ? layoutParams.height
                            : (int) (innerHeight * layoutParams.heightPercent);

                    if (useMaxHeight) {
                        int maxHeight = layoutParams.maxHeight != null
                                ? layoutParams.maxHeight
                                : (int) (innerHeight * layoutParams.maxHeightPercent);

                        height = Math.min(height, maxHeight);
                    }

                    if (useMinHeight) {
                        int minHeight = layoutParams.minHeight != null
                                ? layoutParams.minHeight
                                : (int) (innerHeight * layoutParams.minHeightPercent);

                        height = Math.max(height, minHeight);
                    }

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                } else {
                    if (useMaxHeight) {
                        int maxHeight = layoutParams.maxHeight != null
                                ? layoutParams.maxHeight
                                : (int) (innerHeight * layoutParams.maxHeightPercent);

                        childHeightSpec = MeasureSpec.makeMeasureSpec(maxHeight, MeasureSpec.AT_MOST);
                    }
                }

                if (layoutParams.aspectRatio != null) {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                }
            } else {
                childHeightSpec = flexSpec;

                if (useWidth) {
                    int width = layoutParams.width >= 0
                            ? layoutParams.width
                            : (int) (innerWidth * layoutParams.widthPercent);

                    if (useMaxWidth) {
                        int maxWidth = layoutParams.maxWidth != null
                                ? layoutParams.maxWidth
                                : (int) (innerWidth * layoutParams.maxWidthPercent);

                        width = Math.min(width, maxWidth);
                    }

                    if (useMinWidth) {
                        int minWidth = layoutParams.minWidth != null
                                ? layoutParams.minWidth
                                : (int) (innerWidth * layoutParams.minWidthPercent);

                        width = Math.max(width, minWidth);
                    }

                    childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                } else {
                    if (useMaxWidth) {
                        int maxWidth = layoutParams.maxWidth != null
                                ? layoutParams.maxWidth
                                : (int) (innerWidth * layoutParams.maxWidthPercent);

                        childWidthSpec = MeasureSpec.makeMeasureSpec(maxWidth, MeasureSpec.AT_MOST);
                    }
                }

                if (layoutParams.aspectRatio != null) {
                    int width = (int) (MeasureSpec.getSize(childHeightSpec) * layoutParams.aspectRatio);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                }
            }

            forceChildMeasure(child, childWidthSpec, childHeightSpec);

            childWidthSpec = MeasureSpec.makeMeasureSpec(child.getMeasuredWidth(), MeasureSpec.EXACTLY);
            childHeightSpec = MeasureSpec.makeMeasureSpec(child.getMeasuredHeight(), MeasureSpec.EXACTLY);

            if (layoutParams.aspectRatio == null) {
                if (isHorizontal()) {
                    if (!useHeight) {
                        int height = MeasureSpec.getSize(childHeightSpec);

                        if (useMinHeight) {
                            int minHeight = layoutParams.minHeight != null
                                    ? layoutParams.minHeight
                                    : (int) (innerHeight * layoutParams.minHeightPercent);

                            height = Math.max(height, minHeight);
                        }

                        childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                    }
                } else {
                    if (!useWidth) {
                        int width = MeasureSpec.getSize(childWidthSpec);

                        if (useMinWidth) {
                            int minWidth = layoutParams.minWidth != null
                                    ? layoutParams.minWidth
                                    : (int) (innerWidth * layoutParams.minWidthPercent);

                            width = Math.max(width, minWidth);
                        }

                        childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                    }
                }
            }

            remeasureChild(child, childWidthSpec, childHeightSpec);
        }

        // calculate contentWidth and contentHeight

        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);

            LayoutParams layoutParams = (LayoutParams) child.getLayoutParams();

            boolean isHidden = layoutParams.display == LayoutParams.DISPLAY_NONE;
            boolean isAbsolute = layoutParams.position == LayoutParams.POSITION_ABSOLUTE;

            if (isHidden) {
                continue;
            }

            if (isAbsolute) {
                continue;
            }

            int childWidth = child.getMeasuredWidth();
            int childHeight = child.getMeasuredHeight();

            int marginTop = layoutParams.topMargin;
            int marginLeft = layoutParams.leftMargin;
            int marginBottom = layoutParams.bottomMargin;
            int marginRight = layoutParams.rightMargin;

            int marginX = marginLeft + marginRight;
            int marginY = marginTop + marginBottom;

            int outerWidth = childWidth + marginX;
            int outerHeight = childHeight + marginY;

            if (isHorizontal()) {
                contentWidth += outerWidth;

                contentHeight = Math.max(contentHeight, outerHeight);
            } else {
                contentWidth = Math.max(contentWidth, outerWidth);

                contentHeight += outerHeight;
            }
        }

        contentWidth += paddingX;
        contentHeight += paddingY;

        int resolvedWidth = resolveSizeAndState(contentWidth, widthSpec, 0);
        int resolvedHeight = resolveSizeAndState(contentHeight, heightSpec, 0);

        setMeasuredDimension(resolvedWidth, resolvedHeight);

        if (!isParentViewLayout) {
            onMeasureAbsoluteChildren();
        }
    }

    protected void onMeasureAbsoluteChildren() {
        int measuredWidth = getMeasuredWidth();
        int measuredHeight = getMeasuredHeight();

        // measure absolute children

        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);

            LayoutParams layoutParams = (LayoutParams) child.getLayoutParams();

            boolean isHidden = layoutParams.display == LayoutParams.DISPLAY_NONE;
            boolean isAbsolute = layoutParams.position == LayoutParams.POSITION_ABSOLUTE;

            if (isHidden) {
                continue;
            }

            if (!isAbsolute) {
                continue;
            }

            int childWidthSpec = MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);
            int childHeightSpec = MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

            boolean hasWidth = layoutParams.width >= 0 || layoutParams.widthPercent != null;
            boolean hasHeight = layoutParams.height >= 0 || layoutParams.heightPercent != null;

            boolean hasMinWidth = layoutParams.minWidth != null || layoutParams.minWidthPercent != null;
            boolean hasMinHeight = layoutParams.minHeight != null || layoutParams.minHeightPercent != null;

            boolean hasMaxWidth = layoutParams.maxWidth != null || layoutParams.maxWidthPercent != null;
            boolean hasMaxHeight = layoutParams.maxHeight != null || layoutParams.maxHeightPercent != null;

            boolean hasPositionWidth = (layoutParams.positionLeft != null || layoutParams.positionLeftPercent != null)
                    && (layoutParams.positionRight != null || layoutParams.positionRightPercent != null);

            boolean hasPositionHeight = (layoutParams.positionTop != null || layoutParams.positionTopPercent != null)
                    && (layoutParams.positionBottom != null || layoutParams.positionBottomPercent != null);

            // alias to keep consistency with the other loops

            boolean useWidth = hasWidth;
            boolean useHeight = hasHeight;

            boolean useMinWidth = hasMinWidth;
            boolean useMinHeight = hasMinHeight;

            boolean useMaxWidth = hasMaxWidth;
            boolean useMaxHeight = hasMaxHeight;

            boolean usePositionWidth = hasPositionWidth;
            boolean usePositionHeight = hasPositionHeight;

            if (useWidth) {
                int width = layoutParams.width >= 0
                        ? layoutParams.width
                        : (int) (measuredWidth * layoutParams.widthPercent);

                if (useMaxWidth) {
                    int maxWidth = layoutParams.maxWidth != null
                            ? layoutParams.maxWidth
                            : (int) (measuredWidth * layoutParams.maxWidthPercent);

                    width = Math.min(width, maxWidth);
                }

                if (useMinWidth) {
                    int minWidth = layoutParams.minWidth != null
                            ? layoutParams.minWidth
                            : (int) (measuredWidth * layoutParams.minWidthPercent);

                    width = Math.max(width, minWidth);
                }

                childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
            } else if (usePositionWidth) {
                int left = layoutParams.positionLeft != null
                        ? layoutParams.positionLeft
                        : (int) (measuredWidth * layoutParams.positionLeftPercent);

                int right = layoutParams.positionRight != null
                        ? layoutParams.positionRight
                        : (int) (measuredWidth * layoutParams.positionRightPercent);

                int width = measuredWidth - left - right;

                if (useMaxWidth) {
                    int maxWidth = layoutParams.maxWidth != null
                            ? layoutParams.maxWidth
                            : (int) (measuredWidth * layoutParams.maxWidthPercent);

                    width = Math.min(width, maxWidth);
                }

                if (useMinWidth) {
                    int minWidth = layoutParams.minWidth != null
                            ? layoutParams.minWidth
                            : (int) (measuredWidth * layoutParams.minWidthPercent);

                    width = Math.max(width, minWidth);
                }

                childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
            } else {
                if (useMaxWidth) {
                    int maxWidth = layoutParams.maxWidth != null
                            ? layoutParams.maxWidth
                            : (int) (measuredWidth * layoutParams.maxWidthPercent);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(maxWidth, MeasureSpec.AT_MOST);
                }
            }

            if (useHeight) {
                int height = layoutParams.height >= 0
                        ? layoutParams.height
                        : (int) (measuredHeight * layoutParams.heightPercent);

                if (useMaxHeight) {
                    int maxHeight = layoutParams.maxHeight != null
                            ? layoutParams.maxHeight
                            : (int) (measuredHeight * layoutParams.maxHeightPercent);

                    height = Math.min(height, maxHeight);
                }

                if (useMinHeight) {
                    int minHeight = layoutParams.minHeight != null
                            ? layoutParams.minHeight
                            : (int) (measuredHeight * layoutParams.minHeightPercent);

                    height = Math.max(height, minHeight);
                }

                childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
            } else if (usePositionHeight) {
                int top = layoutParams.positionTop != null
                        ? layoutParams.positionTop
                        : (int) (measuredHeight * layoutParams.positionTopPercent);

                int bottom = layoutParams.positionBottom != null
                        ? layoutParams.positionBottom
                        : (int) (measuredHeight * layoutParams.positionBottomPercent);

                int height = measuredHeight - top - bottom;

                if (useMaxHeight) {
                    int maxHeight = layoutParams.maxHeight != null
                            ? layoutParams.maxHeight
                            : (int) (measuredHeight * layoutParams.maxHeightPercent);

                    height = Math.min(height, maxHeight);
                }

                if (useMinHeight) {
                    int minHeight = layoutParams.minHeight != null
                            ? layoutParams.minHeight
                            : (int) (measuredHeight * layoutParams.minHeightPercent);

                    height = Math.max(height, minHeight);
                }

                childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
            } else {
                if (useMaxHeight) {
                    int maxHeight = layoutParams.maxHeight != null
                            ? layoutParams.maxHeight
                            : (int) (measuredHeight * layoutParams.maxHeightPercent);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(maxHeight, MeasureSpec.AT_MOST);
                }
            }

            if (layoutParams.aspectRatio != null) {
                if (useWidth || usePositionWidth) {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                } else if (useHeight || usePositionHeight) {
                    int width = (int) (MeasureSpec.getSize(childHeightSpec) * layoutParams.aspectRatio);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                }
            }

            forceChildMeasure(child, childWidthSpec, childHeightSpec);

            childWidthSpec = MeasureSpec.makeMeasureSpec(child.getMeasuredWidth(), MeasureSpec.EXACTLY);
            childHeightSpec = MeasureSpec.makeMeasureSpec(child.getMeasuredHeight(), MeasureSpec.EXACTLY);

            if (!(useWidth || usePositionWidth)) {
                int width = MeasureSpec.getSize(childWidthSpec);

                if (useMinWidth) {
                    int minWidth = layoutParams.minWidth != null
                            ? layoutParams.minWidth
                            : (int) (measuredWidth * layoutParams.minWidthPercent);

                    width = Math.max(width, minWidth);
                }

                childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
            }

            if (!(useHeight || usePositionHeight)) {
                int height = MeasureSpec.getSize(childHeightSpec);

                if (useMinHeight) {
                    int minHeight = layoutParams.minHeight != null
                            ? layoutParams.minHeight
                            : (int) (measuredHeight * layoutParams.minHeightPercent);

                    height = Math.max(height, minHeight);
                }

                childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
            }

            if (
                    layoutParams.aspectRatio != null
                            && !(useWidth || usePositionWidth)
                            && !(useHeight || usePositionHeight)
            ) {
                boolean hasMinOrMaxWidth = hasMinWidth || hasMaxWidth;
                boolean hasMinOrMaxHeight = hasMinHeight || hasMaxHeight;

                if (hasMinOrMaxWidth) {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                } else if (hasMinOrMaxHeight) {
                    int width = (int) (MeasureSpec.getSize(childHeightSpec) * layoutParams.aspectRatio);

                    childWidthSpec = MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY);
                } else {
                    int height = (int) (MeasureSpec.getSize(childWidthSpec) * layoutParams.aspectRatio);

                    childHeightSpec = MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY);
                }
            }

            remeasureChild(child, childWidthSpec, childHeightSpec);
        }
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        // System.out.println("onLayout " + id);

        if (getChildCount() == 0) {
            return;
        }

        int measuredWidth = getMeasuredWidth();
        int measuredHeight = getMeasuredHeight();

        int paddingTop = getPaddingTop();
        int paddingLeft = getPaddingLeft();
        int paddingBottom = getPaddingBottom();
        int paddingRight = getPaddingRight();

        int paddingX = paddingLeft + paddingRight;
        int paddingY = paddingTop + paddingBottom;

        int innerWidth = measuredWidth - paddingX;
        int innerHeight = measuredHeight - paddingY;

        int contentWidth = 0;
        int contentHeight = 0;

        int top = 0;
        int left = 0;

        int relativeChildCount = 0;

        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);

            LayoutParams layoutParams = (LayoutParams) child.getLayoutParams();

            boolean isHidden = layoutParams.display == LayoutParams.DISPLAY_NONE;
            boolean isAbsolute = layoutParams.position == LayoutParams.POSITION_ABSOLUTE;

            if (isHidden) {
                continue;
            }

            if (isAbsolute) {
                continue;
            }

            relativeChildCount++;

            int childWidth = child.getMeasuredWidth();
            int childHeight = child.getMeasuredHeight();

            int marginTop = layoutParams.topMargin;
            int marginLeft = layoutParams.leftMargin;
            int marginBottom = layoutParams.bottomMargin;
            int marginRight = layoutParams.rightMargin;

            int marginX = marginLeft + marginRight;
            int marginY = marginTop + marginBottom;

            int outerWidth = childWidth + marginX;
            int outerHeight = childHeight + marginY;

            if (isHorizontal()) {
                contentWidth += outerWidth;

                contentHeight = Math.max(contentHeight, outerHeight);
            } else {
                contentWidth = Math.max(contentWidth, outerWidth);

                contentHeight += outerHeight;
            }
        }

        int spaceDistribution = 0;
        int spaceRemainder = 0;

        // calculate left or top

        if (isHorizontal()) {
            int startLeft = paddingLeft;
            int centerLeft = paddingLeft + innerWidth / 2 - contentWidth / 2;
            int endLeft = measuredWidth - paddingRight - contentWidth;

            switch (justifyContent) {
                case LayoutParams.JUSTIFY_CONTENT_FLEX_START: {
                    left = isReversed() ? endLeft : startLeft;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_FLEX_END: {
                    left = isReversed() ? startLeft : endLeft;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_START: {
                    left = startLeft;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_END: {
                    left = endLeft;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_CENTER: {
                    left = centerLeft;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_SPACE_BETWEEN: {
                    if (relativeChildCount == 1) {
                        left = isReversed() ? endLeft : startLeft;
                    } else {
                        left = startLeft;
                    }

                    if (relativeChildCount >= 2) {
                        spaceDistribution = (innerWidth - contentWidth) / (relativeChildCount - 1);

                        spaceRemainder = (innerWidth - contentWidth) % (relativeChildCount - 1);
                    }

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_SPACE_AROUND: {
                    left = startLeft;

                    if (relativeChildCount >= 1) {
                        spaceDistribution = (innerWidth - contentWidth) / relativeChildCount;

                        spaceRemainder = (innerWidth - contentWidth) % relativeChildCount;

                        left += spaceDistribution / 2;

                        spaceRemainder += spaceDistribution % 2;
                    }

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_SPACE_EVENLY: {
                    left = startLeft;

                    if (relativeChildCount >= 1) {
                        spaceDistribution = (innerWidth - contentWidth) / (relativeChildCount + 1);

                        spaceRemainder = (innerWidth - contentWidth) % (relativeChildCount + 1);

                        left += spaceDistribution;
                    }

                    break;
                }
            }
        } else {
            int startTop = paddingTop;
            int centerTop = paddingTop + innerHeight / 2 - contentHeight / 2;
            int endTop = measuredHeight - paddingBottom - contentHeight;

            switch (justifyContent) {
                case LayoutParams.JUSTIFY_CONTENT_FLEX_START: {
                    top = isReversed() ? endTop : startTop;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_FLEX_END: {
                    top = isReversed() ? startTop : endTop;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_START: {
                    top = startTop;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_END: {
                    top = endTop;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_CENTER: {
                    top = centerTop;

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_SPACE_BETWEEN: {
                    if (relativeChildCount == 1) {
                        top = isReversed() ? endTop : startTop;
                    } else {
                        top = startTop;
                    }

                    if (relativeChildCount >= 2) {
                        spaceDistribution = (innerHeight - contentHeight) / (relativeChildCount - 1);

                        spaceRemainder = (innerHeight - contentHeight) % (relativeChildCount - 1);
                    }

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_SPACE_AROUND: {
                    top = startTop;

                    if (relativeChildCount >= 1) {
                        spaceDistribution = (innerHeight - contentHeight) / relativeChildCount;

                        spaceRemainder = (innerHeight - contentHeight) % relativeChildCount;

                        top += spaceDistribution / 2;

                        spaceRemainder += spaceDistribution % 2;
                    }

                    break;
                }

                case LayoutParams.JUSTIFY_CONTENT_SPACE_EVENLY: {
                    top = startTop;

                    if (relativeChildCount >= 1) {
                        spaceDistribution = (innerHeight - contentHeight) / (relativeChildCount + 1);

                        spaceRemainder = (innerHeight - contentHeight) % (relativeChildCount + 1);

                        top += spaceDistribution;
                    }

                    break;
                }
            }
        }

        // layout relative children

        for (
                int i = isReversed() ? getChildCount() - 1 : 0;
                isReversed() ? i >= 0 : i < getChildCount();
                i += isReversed() ? -1 : 1
        ) {
            View child = getChildAt(i);

            LayoutParams layoutParams = (LayoutParams) child.getLayoutParams();

            boolean isHidden = layoutParams.display == LayoutParams.DISPLAY_NONE;
            boolean isAbsolute = layoutParams.position == LayoutParams.POSITION_ABSOLUTE;

            if (isHidden) {
                continue;
            }

            if (isAbsolute) {
                continue;
            }

            int childWidth = child.getMeasuredWidth();
            int childHeight = child.getMeasuredHeight();

            int marginTop = layoutParams.topMargin;
            int marginLeft = layoutParams.leftMargin;
            int marginBottom = layoutParams.bottomMargin;
            int marginRight = layoutParams.rightMargin;

            int marginX = marginLeft + marginRight;
            int marginY = marginTop + marginBottom;

            int outerWidth = childWidth + marginX;
            int outerHeight = childHeight + marginY;

            Integer positionTop = layoutParams.positionTop;
            Float positionTopPercent = layoutParams.positionTopPercent;

            Integer positionLeft = layoutParams.positionLeft;
            Float positionLeftPercent = layoutParams.positionLeftPercent;

            Integer positionBottom = layoutParams.positionBottom;
            Float positionBottomPercent = layoutParams.positionBottomPercent;

            Integer positionRight = layoutParams.positionRight;
            Float positionRightPercent = layoutParams.positionRightPercent;

            int x = 0;
            int y = 0;

            int alignSelf = layoutParams.alignSelf != null
                    ? layoutParams.alignSelf
                    : alignItems;

            if (isHorizontal()) {
                x = left + marginLeft;

                int startY = paddingTop + marginTop;
                int centerY = paddingTop + marginTop + innerHeight / 2 - outerHeight / 2;
                int endY = measuredHeight - paddingBottom - marginBottom - childHeight;

                switch (alignSelf) {
                    case LayoutParams.ALIGN_ITEMS_FLEX_START:
                    case LayoutParams.ALIGN_ITEMS_START: {
                        y = startY;

                        break;
                    }

                    case LayoutParams.ALIGN_ITEMS_FLEX_END:
                    case LayoutParams.ALIGN_ITEMS_END: {
                        y = endY;

                        break;
                    }

                    case LayoutParams.ALIGN_ITEMS_CENTER: {
                        y = centerY;

                        break;
                    }
                }
            } else {
                y = top + marginTop;

                int startX = paddingLeft + marginLeft;
                int centerX = paddingLeft + marginLeft + innerWidth / 2 - outerWidth / 2;
                int endX = measuredWidth - paddingRight - marginRight - childWidth;

                switch (alignSelf) {
                    case LayoutParams.ALIGN_ITEMS_FLEX_START:
                    case LayoutParams.ALIGN_ITEMS_START: {
                        x = startX;

                        break;
                    }

                    case LayoutParams.ALIGN_ITEMS_FLEX_END:
                    case LayoutParams.ALIGN_ITEMS_END: {
                        x = endX;

                        break;
                    }

                    case LayoutParams.ALIGN_ITEMS_CENTER: {
                        x = centerX;

                        break;
                    }
                }
            }

            if (positionLeft != null) {
                x += positionLeft;
            } else if (positionLeftPercent != null) {
                x += (int) measuredWidth * positionLeftPercent;
            } else if (positionRight != null) {
                x -= positionRight;
            } else if (positionRightPercent != null) {
                x -= (int) measuredWidth * positionRightPercent;
            }

            if (positionTop != null) {
                y += positionTop;
            } else if (positionTopPercent != null) {
                y += (int) measuredHeight * positionTopPercent;
            } else if (positionBottom != null) {
                y -= positionBottom;
            } else if (positionBottomPercent != null) {
                y -= (int) measuredHeight * positionBottomPercent;
            }

            layoutChild(child, x, y, x + childWidth, y + childHeight);

            if (isHorizontal()) {
                left += outerWidth + spaceDistribution;
            } else {
                top += outerHeight + spaceDistribution;
            }

            if (spaceRemainder > 0) {
                if (isHorizontal()) {
                    left++;
                } else {
                    top++;
                }

                spaceRemainder--;
            }
        }

        // layout absolute children

        for (int i = 0; i < getChildCount(); i++) {
            View child = getChildAt(i);

            LayoutParams layoutParams = (LayoutParams) child.getLayoutParams();

            boolean isHidden = layoutParams.display == LayoutParams.DISPLAY_NONE;
            boolean isAbsolute = layoutParams.position == LayoutParams.POSITION_ABSOLUTE;

            if (isHidden) {
                continue;
            }

            if (!isAbsolute) {
                continue;
            }

            int childWidth = child.getMeasuredWidth();
            int childHeight = child.getMeasuredHeight();

            int marginTop = layoutParams.topMargin;
            int marginLeft = layoutParams.leftMargin;
            int marginBottom = layoutParams.bottomMargin;
            int marginRight = layoutParams.rightMargin;

            int marginX = marginLeft + marginRight;
            int marginY = marginTop + marginBottom;

            int outerWidth = childWidth + marginX;
            int outerHeight = childHeight + marginY;

            Integer positionTop = layoutParams.positionTop;
            Float positionTopPercent = layoutParams.positionTopPercent;

            Integer positionLeft = layoutParams.positionLeft;
            Float positionLeftPercent = layoutParams.positionLeftPercent;

            Integer positionBottom = layoutParams.positionBottom;
            Float positionBottomPercent = layoutParams.positionBottomPercent;

            Integer positionRight = layoutParams.positionRight;
            Float positionRightPercent = layoutParams.positionRightPercent;

            int x = 0;
            int y = 0;

            int alignSelf = layoutParams.alignSelf != null ? layoutParams.alignSelf : alignItems;

            int startX = paddingLeft + marginLeft;
            int centerX = paddingLeft + marginLeft + innerWidth / 2 - outerWidth / 2;
            int endX = measuredWidth - paddingRight - marginRight - childWidth;

            int startY = paddingTop + marginTop;
            int centerY = paddingTop + marginTop + innerHeight / 2 - outerHeight / 2;
            int endY = measuredHeight - paddingBottom - marginBottom - childHeight;

            if (isHorizontal()) {
                switch (justifyContent) {
                    case LayoutParams.JUSTIFY_CONTENT_FLEX_START:
                    case LayoutParams.JUSTIFY_CONTENT_SPACE_BETWEEN: {
                        x = isReversed() ? endX : startX;

                        break;
                    }

                    case LayoutParams.JUSTIFY_CONTENT_FLEX_END: {
                        x = isReversed() ? startX : endX;

                        break;
                    }

                    case LayoutParams.JUSTIFY_CONTENT_START: {
                        x = startX;

                        break;
                    }

                    case LayoutParams.JUSTIFY_CONTENT_END: {
                        x = endX;

                        break;
                    }

                    case LayoutParams.JUSTIFY_CONTENT_CENTER:
                    case LayoutParams.JUSTIFY_CONTENT_SPACE_AROUND:
                    case LayoutParams.JUSTIFY_CONTENT_SPACE_EVENLY: {
                        x = centerX;

                        break;
                    }
                }

                switch (alignSelf) {
                    case LayoutParams.ALIGN_ITEMS_FLEX_START:
                    case LayoutParams.ALIGN_ITEMS_START: {
                        y = startY;

                        break;
                    }

                    case LayoutParams.ALIGN_ITEMS_FLEX_END:
                    case LayoutParams.ALIGN_ITEMS_END: {
                        y = endY;

                        break;
                    }

                    case LayoutParams.ALIGN_ITEMS_CENTER: {
                        y = centerY;

                        break;
                    }
                }
            } else {
                switch (justifyContent) {
                    case LayoutParams.JUSTIFY_CONTENT_FLEX_START:
                    case LayoutParams.JUSTIFY_CONTENT_SPACE_BETWEEN: {
                        y = isReversed() ? endY : startY;

                        break;
                    }

                    case LayoutParams.JUSTIFY_CONTENT_FLEX_END: {
                        y = isReversed() ? startY : endY;

                        break;
                    }

                    case LayoutParams.JUSTIFY_CONTENT_START: {
                        y = startY;

                        break;
                    }

                    case LayoutParams.JUSTIFY_CONTENT_END: {
                        y = endY;

                        break;
                    }

                    case LayoutParams.JUSTIFY_CONTENT_CENTER:
                    case LayoutParams.JUSTIFY_CONTENT_SPACE_AROUND:
                    case LayoutParams.JUSTIFY_CONTENT_SPACE_EVENLY: {
                        y = centerY;

                        break;
                    }
                }

                switch (alignSelf) {
                    case LayoutParams.ALIGN_ITEMS_FLEX_START:
                    case LayoutParams.ALIGN_ITEMS_START: {
                        x = startX;

                        break;
                    }

                    case LayoutParams.ALIGN_ITEMS_FLEX_END:
                    case LayoutParams.ALIGN_ITEMS_END: {
                        x = endX;

                        break;
                    }

                    case LayoutParams.ALIGN_ITEMS_CENTER: {
                        x = centerX;

                        break;
                    }
                }
            }

            if (positionLeft != null) {
                x = positionLeft + marginLeft;
            } else if (positionLeftPercent != null) {
                x = (int) (measuredWidth * positionLeftPercent) + marginLeft;
            } else if (positionRight != null) {
                x = measuredWidth - positionRight - marginRight - childWidth;
            } else if (positionRightPercent != null) {
                x = measuredWidth - (int) (measuredWidth * positionRightPercent) - marginRight - childWidth;
            }

            if (positionTop != null) {
                y = positionTop + marginTop;
            } else if (positionTopPercent != null) {
                y = (int) (measuredHeight * positionTopPercent) + marginTop;
            } else if (positionBottom != null) {
                y = measuredHeight - positionBottom - marginBottom - childHeight;
            } else if (positionBottomPercent != null) {
                y = measuredHeight - (int) (measuredHeight * positionBottomPercent) - marginBottom - childHeight;
            }

            layoutChild(child, x, y, x + childWidth, y + childHeight);
        }
    }

    @Override
    protected void dispatchDraw(Canvas canvas) {
        // System.out.println("dispatchDraw " + id);

        if (overflow == OVERFLOW_VISIBLE) {
            super.dispatchDraw(canvas);

            return;
        }

        int save = canvas.save();

        int viewWidth = getWidth();
        int viewHeight = getHeight();

        path.reset();

        rect.set(0, 0, viewWidth, viewHeight);

        path.addRoundRect(rect, radii, Path.Direction.CW);

        canvas.clipPath(path);

        super.dispatchDraw(canvas);

        canvas.restoreToCount(save);
    }

    private void forceChildMeasure(View view, int widthSpec, int heightSpec) {
        view.forceLayout();

        view.measure(widthSpec, heightSpec);
    }

    // in remeasure, specs are always EXACTLY

    private void remeasureChild(View view, int widthSpec, int heightSpec) {
        int currentWidthSpec = MeasureSpec.makeMeasureSpec(view.getMeasuredWidth(), MeasureSpec.EXACTLY);
        int currentHeightSpec = MeasureSpec.makeMeasureSpec(view.getMeasuredHeight(), MeasureSpec.EXACTLY);

        boolean isViewLayout = view instanceof ViewLayout;

        boolean hasSpecChanged = widthSpec != currentWidthSpec || heightSpec != currentHeightSpec;

        boolean remeasure = isViewLayout || hasSpecChanged;

        if (!remeasure) {
            return;
        }

        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.remeasured = true;

        view.measure(widthSpec, heightSpec);

        layoutParams.remeasured = false;
    }

    private void layoutChild(View view, int l, int t, int r, int b) {
        view.layout(l, t, r, b);

        LayoutParams layoutParams = (LayoutParams) view.getLayoutParams();

        layoutParams.callOnLayout();
    }

    public static class LayoutParams extends ViewGroup.MarginLayoutParams {
        public boolean remeasured = false;

        public int position = LayoutParams.POSITION_RELATIVE;

        public int display = LayoutParams.DISPLAY_FLEX;

        public Float widthPercent;
        public Float heightPercent;

        public Integer minWidth;
        public Float minWidthPercent;

        public Integer minHeight;
        public Float minHeightPercent;

        public Integer maxWidth;
        public Float maxWidthPercent;

        public Integer maxHeight;
        public Float maxHeightPercent;

        public Integer flex;
        public Integer alignSelf;

        public Float aspectRatio;

        public Integer positionTop;
        public Float positionTopPercent;

        public Integer positionLeft;
        public Float positionLeftPercent;

        public Integer positionBottom;
        public Float positionBottomPercent;

        public Integer positionRight;
        public Float positionRightPercent;

        public Map<String, OnLayoutClosure> onLayoutClosures = new HashMap<>();

        public static int POSITION_RELATIVE = 0;
        public static int POSITION_ABSOLUTE = 1;

        public static int DISPLAY_FLEX = 0;
        public static int DISPLAY_NONE = 1;

        public static final int FLEX_DIRECTION_ROW = 0;
        public static final int FLEX_DIRECTION_ROW_REVERSE = 1;
        public static final int FLEX_DIRECTION_COLUMN = 2;
        public static final int FLEX_DIRECTION_COLUMN_REVERSE = 3;

        public static final int JUSTIFY_CONTENT_FLEX_START = 0;
        public static final int JUSTIFY_CONTENT_FLEX_END = 1;
        public static final int JUSTIFY_CONTENT_START = 2;
        public static final int JUSTIFY_CONTENT_END = 3;
        public static final int JUSTIFY_CONTENT_CENTER = 4;
        public static final int JUSTIFY_CONTENT_SPACE_BETWEEN = 5;
        public static final int JUSTIFY_CONTENT_SPACE_AROUND = 6;
        public static final int JUSTIFY_CONTENT_SPACE_EVENLY = 7;

        public static final int ALIGN_ITEMS_FLEX_START = 0;
        public static final int ALIGN_ITEMS_FLEX_END = 1;
        public static final int ALIGN_ITEMS_START = 2;
        public static final int ALIGN_ITEMS_END = 3;
        public static final int ALIGN_ITEMS_CENTER = 4;

        public LayoutParams(Context context, AttributeSet attrs) {
            super(context, attrs);
        }

        public LayoutParams(int width, int height) {
            super(width, height);
        }

        public LayoutParams(ViewGroup.LayoutParams source) {
            super(source);
        }

        public void callOnLayout() {
            for (OnLayoutClosure onLayoutClosure : onLayoutClosures.values()) {
                onLayoutClosure.execute();
            }
        }

        @FunctionalInterface
        public interface OnLayoutClosure {
            void execute();
        }
    }
}
