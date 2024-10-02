package com.iconshot.detonator.element.scrollviewelement;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.RectF;
import android.view.View;
import android.widget.ScrollView;

import com.iconshot.detonator.layout.ViewLayout;

public class CustomScrollView extends ScrollView {
    private float[] radii;

    private final RectF rect = new RectF(0, 0, 0, 0);

    private final Path path = new Path();

    public CustomScrollView(Context context) {
        super(context);
    }

    public void setRadii(float[] radii) {
        this.radii = radii;

        this.invalidate();
    }

    @Override
    protected void onMeasure(int widthSpec, int heightSpec) {
        int specWidth = MeasureSpec.getSize(widthSpec);
        int specHeight = MeasureSpec.getSize(heightSpec);

        int specWidthMode = MeasureSpec.getMode(widthSpec);
        int specHeightMode = MeasureSpec.getMode(heightSpec);

        ViewLayout.LayoutParams layoutParams = (ViewLayout.LayoutParams) getLayoutParams();

        if (layoutParams.remeasured) {
            setMeasuredDimension(specWidth, specHeight);

            return;
        }

        int paddingTop = getPaddingTop();
        int paddingLeft = getPaddingLeft();
        int paddingBottom = getPaddingBottom();
        int paddingRight = getPaddingRight();

        int paddingX = paddingLeft + paddingRight;
        int paddingY = paddingTop + paddingBottom;

        int innerWidth = specWidth - paddingX;

        int contentWidth = 0;
        int contentHeight = 0;

        View child = getChildAt(0);

        int childWidthSpec = MeasureSpec.makeMeasureSpec(innerWidth, specWidthMode);
        int childHeightSpec = MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

        child.measure(childWidthSpec, childHeightSpec);

        int childWidth = child.getMeasuredWidth();
        int childHeight = child.getMeasuredHeight();

        contentWidth += childWidth;
        contentHeight += childHeight;

        contentWidth += paddingX;
        contentHeight += paddingY;

        int resolvedWidth = resolveSizeAndState(contentWidth, widthSpec, 0);
        int resolvedHeight = resolveSizeAndState(contentHeight, heightSpec, 0);

        setMeasuredDimension(resolvedWidth, resolvedHeight);
    }

    @Override
    protected void dispatchDraw(Canvas canvas) {
        int save = canvas.save();

        int viewWidth = getWidth();
        int viewHeight = getHeight();

        path.reset();

        int scrollY = getScrollY();

        rect.set(0, scrollY, viewWidth, scrollY + viewHeight);

        path.addRoundRect(rect, radii, Path.Direction.CW);

        canvas.clipPath(path);

        super.dispatchDraw(canvas);

        canvas.restoreToCount(save);
    }
}
