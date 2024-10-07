package com.iconshot.detonator.element.verticalscrollviewelement;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.RectF;
import android.os.Handler;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ScrollView;

import androidx.annotation.NonNull;

import com.iconshot.detonator.layout.ViewLayout;

public class CustomVerticalScrollView extends ScrollView {
    private boolean paginated = false;

    private int page = 0;

    private OnPageChangeListener onPageChangeListener;

    private float[] radii;

    private final RectF rect = new RectF(0, 0, 0, 0);

    private final Path path = new Path();

    private Handler scrollHandler = new Handler();

    private Runnable scrollRunnable;

    private float initialScrollY;

    public CustomVerticalScrollView(Context context) {
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

        int childWidthSpec = MeasureSpec.makeMeasureSpec(innerWidth, specWidthMode);

        int childHeightSpec = paginated
                ? MeasureSpec.makeMeasureSpec(innerHeight * child.getChildCount(), MeasureSpec.EXACTLY)
                : MeasureSpec.makeMeasureSpec(0, MeasureSpec.UNSPECIFIED);

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

    @Override
    public void fling(int velocityY) {
        if (!paginated) {
            super.fling(velocityY);

            return;
        }

        int targetPage = page;

        if (velocityY > 0) {
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
                return true;
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
            case MotionEvent.ACTION_DOWN: {
                initialScrollY = getScrollY();

                break;
            }

            case MotionEvent.ACTION_UP: {
                scrollRunnable = new Runnable() {
                    @Override
                    public void run() {
                        float deltaY = getScrollY() - initialScrollY;

                        int height = getHeight();

                        int targetPage = page;

                        float half = height / 2;

                        if (Math.abs(deltaY) >= half) {
                            if (deltaY > 0) {
                                targetPage++;
                            } else {
                                targetPage--;
                            }
                        }

                        scrollToPage(targetPage);
                    }
                };

                scrollHandler.postDelayed(scrollRunnable, 100);
            }
        }

        return super.onTouchEvent(event);
    }

    public void scrollToPage(int page) {
        if (!paginated) {
            return;
        }

        int height = getHeight();

        ViewLayout child = (ViewLayout) getChildAt(0);

        int pagesCount = child.getChildCount();

        int tmpPage = Math.max(0, Math.min(page, pagesCount - 1));

        if (tmpPage != this.page) {
            this.page = tmpPage;

            onPageChangeListener.onPageChange(tmpPage);
        }

        smoothScrollTo(0, tmpPage * height);
    }

    @FunctionalInterface
    public interface OnPageChangeListener {
        void onPageChange(int page);
    }
}
