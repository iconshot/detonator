package com.iconshot.detonator.element.horizontalscrollviewelement;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.RectF;
import android.os.Handler;
import android.view.MotionEvent;
import android.view.ViewConfiguration;
import android.widget.HorizontalScrollView;

import com.iconshot.detonator.layout.ViewLayout;

public class CustomHorizontalScrollView extends HorizontalScrollView {
    private boolean paginated = false;

    private int page = 0;

    private OnPageChangeListener onPageChangeListener;

    private float[] radii;

    private final RectF rect = new RectF(0, 0, 0, 0);

    private final Path path = new Path();

    private Handler scrollHandler = new Handler();

    private Runnable scrollRunnable;

    private float initialX = 0;

    public CustomHorizontalScrollView(Context context) {
        super(context);
    }

    public void setPaginated(boolean paginated) {
        this.paginated = paginated;
    }

    public void setOnPageChangeListener(OnPageChangeListener onPageChangeListener) {
        this.onPageChangeListener = onPageChangeListener;
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
        int innerHeight = specHeight - paddingY;

        int contentWidth = 0;
        int contentHeight = 0;

        ViewLayout child = (ViewLayout) getChildAt(0);

        int childWidthSpec = paginated
                ? MeasureSpec.makeMeasureSpec(innerWidth * child.getChildCount(), MeasureSpec.EXACTLY)
                : MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

        int childHeightSpec = MeasureSpec.makeMeasureSpec(innerHeight, specHeightMode);

        child.forceLayout();

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

        int scrollX = getScrollX();

        rect.set(scrollX, 0, scrollX + viewWidth, viewHeight);

        path.addRoundRect(rect, radii, Path.Direction.CW);

        canvas.clipPath(path);

        super.dispatchDraw(canvas);

        canvas.restoreToCount(save);
    }

    @Override
    public void fling(int velocityX) {
        if (!paginated) {
            super.fling(velocityX);

            return;
        }

        int targetPage = page;

        if (velocityX > 0) {
            targetPage++;
        } else {
            targetPage--;
        }

        scrollToPage(targetPage);

        scrollHandler.removeCallbacks(scrollRunnable);
    }

    @Override
    public boolean onInterceptTouchEvent(MotionEvent event) {
        if (!paginated) {
            return super.onInterceptTouchEvent(event);
        }

        switch (event.getAction()) {
            case MotionEvent.ACTION_DOWN: {
                initialX = event.getX();

                return false;
            }

            case MotionEvent.ACTION_MOVE: {
                float deltaX = Math.abs(event.getX() - initialX);

                int slop = ViewConfiguration.get(getContext()).getScaledTouchSlop();

                if (deltaX > slop) {
                    return true;
                }
            }
        }

        return super.onInterceptTouchEvent(event);
    }

    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (!paginated) {
            return super.onTouchEvent(event);
        }

        switch (event.getAction()) {
            case MotionEvent.ACTION_UP: {
                scrollRunnable = new Runnable() {
                    @Override
                    public void run() {
                        float deltaX = event.getX() - initialX;

                        int width = getWidth();

                        int targetPage = page;

                        float half = width / 2;

                        if (Math.abs(deltaX) >= half) {
                            if (deltaX < initialX) {
                                targetPage++;
                            } else {
                                targetPage--;
                            }
                        }

                        scrollToPage(targetPage);
                    }
                };

                scrollHandler.postDelayed(scrollRunnable, 10);
            }
        }

        return super.onTouchEvent(event);
    }

    public void scrollToPage(int page) {
        if (!paginated) {
            return;
        }

        int width = getWidth();

        ViewLayout child = (ViewLayout) getChildAt(0);

        int pagesCount = child.getChildCount();

        int tmpPage = Math.max(0, Math.min(page, pagesCount - 1));

        if (tmpPage != this.page) {
            this.page = tmpPage;

            onPageChangeListener.onPageChange(tmpPage);
        }

        smoothScrollTo(tmpPage * width, 0);
    }

    @FunctionalInterface
    public interface OnPageChangeListener {
        void onPageChange(int page);
    }
}