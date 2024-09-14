package com.iconshot.detonator.element.videoelement;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Path;
import android.graphics.RectF;
import android.media.MediaPlayer;
import android.view.View;
import android.view.ViewGroup;

public class VideoLayout extends ViewGroup {
    public static final int OBJECT_FIT_COVER = 0;
    public static final int OBJECT_FIT_CONTAIN = 1;
    public static final int OBJECT_FIT_FILL = 2;

    private int objectFit = OBJECT_FIT_COVER;

    private MediaPlayer mediaPlayer;

    private float[] radii;

    private final RectF rect = new RectF(0, 0, 0, 0);

    private final Path path = new Path();

    public VideoLayout(Context context) {
        super(context);
    }

    public void setMediaPlayer(MediaPlayer mediaPlayer) {
        this.mediaPlayer = mediaPlayer;
    }

    public void setRadii(float[] radii) {
        this.radii = radii;

        this.invalidate();
    }

    public void setObjectFit(int objectFit) {
        if (this.objectFit == objectFit) {
            return;
        }

        this.objectFit = objectFit;

        requestLayout();
    }

    @Override
    protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
        int specWidth = MeasureSpec.getSize(widthMeasureSpec);
        int specHeight = MeasureSpec.getSize(heightMeasureSpec);

        View child = getChildAt(0);

        int childWidth = specWidth;
        int childHeight = specHeight;

        if (mediaPlayer != null) {
            int videoWidth = mediaPlayer.getVideoWidth();
            int videoHeight = mediaPlayer.getVideoHeight();

            switch (objectFit) {
                case OBJECT_FIT_COVER: {
                    float videoAspectRatio = (float) videoWidth / videoHeight;
                    float viewAspectRatio = (float) specWidth / specHeight;

                    if (videoAspectRatio > viewAspectRatio) {
                        childWidth = (int) (specHeight * videoAspectRatio);
                        childHeight = specHeight;
                    } else {
                        childWidth = specWidth;
                        childHeight = (int) (specWidth / videoAspectRatio);
                    }

                    break;
                }

                case OBJECT_FIT_CONTAIN: {
                    float videoAspectRatio = (float) videoWidth / videoHeight;
                    float viewAspectRatio = (float) specWidth / specHeight;

                    if (videoAspectRatio > viewAspectRatio) {
                        childWidth = specWidth;
                        childHeight = (int) (specWidth / videoAspectRatio);
                    } else {
                        childWidth = (int) (specHeight * videoAspectRatio);
                        childHeight = specHeight;
                    }

                    break;
                }

                case OBJECT_FIT_FILL: {
                    childWidth = specWidth;
                    childHeight = specHeight;

                    break;
                }
            }
        }

        child.measure(
                MeasureSpec.makeMeasureSpec(childWidth, MeasureSpec.EXACTLY),
                MeasureSpec.makeMeasureSpec(childHeight, MeasureSpec.EXACTLY)
        );

        setMeasuredDimension(specWidth, specHeight);
    }

    @Override
    protected void onLayout(boolean changed, int l, int t, int r, int b) {
        int measuredWidth = getMeasuredWidth();
        int measuredHeight = getMeasuredHeight();

        View child = getChildAt(0);

        int childWidth = child.getMeasuredWidth();
        int childHeight = child.getMeasuredHeight();

        int childLeft = (measuredWidth - childWidth) / 2;
        int childTop = (measuredHeight - childHeight) / 2;

        child.layout(childLeft, childTop, childLeft + childWidth, childTop + childHeight);

        child.setAlpha(mediaPlayer == null ? 0 : 1);
    }

    @Override
    protected void dispatchDraw(Canvas canvas) {
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
}
