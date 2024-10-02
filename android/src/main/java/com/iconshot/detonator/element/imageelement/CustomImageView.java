package com.iconshot.detonator.element.imageelement;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Path;
import android.graphics.RectF;
import android.graphics.drawable.BitmapDrawable;

import androidx.appcompat.widget.AppCompatImageView;

public class CustomImageView extends AppCompatImageView {
    private float[] radii;

    private final RectF rect = new RectF(0, 0, 0, 0);

    private final Path path = new Path();

    private final Paint paint = new Paint(Paint.ANTI_ALIAS_FLAG);

    public CustomImageView(Context context) {
        super(context);
    }

    public void setRadii(float[] radii) {
        this.radii = radii;

        this.invalidate();
    }

    @Override
    protected void onDraw(Canvas canvas) {
        BitmapDrawable drawable = (BitmapDrawable) getDrawable();

        if (drawable == null) {
            return;
        }

        Bitmap bitmap = drawable.getBitmap();

        int viewWidth = getWidth();
        int viewHeight = getHeight();

        int bitmapWidth = bitmap.getWidth();
        int bitmapHeight = bitmap.getHeight();

        path.reset();

        rect.set(0, 0, viewWidth, viewHeight);

        path.addRoundRect(rect, radii, Path.Direction.CW);

        canvas.clipPath(path);

        ScaleType scaleType = getScaleType();

        switch (scaleType) {
            case CENTER_CROP: {
                float viewRatio = (float) viewWidth / viewHeight;
                float bitmapRatio = (float) bitmapWidth / bitmapHeight;

                if (bitmapRatio > viewRatio) {
                    float scale = (float) viewHeight / bitmapHeight;

                    float dx = (viewWidth - bitmapWidth * scale) / 2;

                    canvas.translate(dx, 0);

                    canvas.scale(scale, scale);
                } else {
                    float scale = (float) viewWidth / bitmapWidth;

                    float dy = (viewHeight - bitmapHeight * scale) / 2;

                    canvas.translate(0, dy);

                    canvas.scale(scale, scale);
                }

                break;
            }

            case CENTER_INSIDE: {
                float scale = Math.min((float) viewWidth / bitmapWidth, (float) viewHeight / bitmapHeight);

                float dx = (viewWidth - bitmapWidth * scale) / 2;
                float dy = (viewHeight - bitmapHeight * scale) / 2;

                canvas.translate(dx, dy);

                canvas.scale(scale, scale);

                break;
            }

            case FIT_XY: {
                canvas.scale(
                        (float) viewWidth / bitmapWidth,
                        (float) viewHeight / bitmapHeight
                );

                break;
            }
        }

        canvas.drawBitmap(bitmap, 0, 0, paint);
    }
}
