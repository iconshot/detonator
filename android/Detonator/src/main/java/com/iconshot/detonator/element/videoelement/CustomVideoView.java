package com.iconshot.detonator.element.videoelement;

import android.content.Context;
import android.widget.VideoView;

public class CustomVideoView extends VideoView {
    public CustomVideoView(Context context) {
        super(context);
    }

    protected void onMeasure(int widthSpec, int heightSpec) {
        int specWidth = MeasureSpec.getSize(widthSpec);
        int specHeight = MeasureSpec.getSize(heightSpec);

        int specWidthMode = MeasureSpec.getMode(widthSpec);
        int specHeightMode = MeasureSpec.getMode(heightSpec);

        if (specWidthMode == MeasureSpec.EXACTLY && specHeightMode == MeasureSpec.EXACTLY) {
            setMeasuredDimension(specWidth, specHeight);

            return;
        }

        super.onMeasure(widthSpec, heightSpec);
    }
}
