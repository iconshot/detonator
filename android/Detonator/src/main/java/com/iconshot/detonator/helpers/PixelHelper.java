package com.iconshot.detonator.helpers;

public class PixelHelper {

    public static int dpToPx(float size) {
        float scale = ContextHelper.context.getResources().getDisplayMetrics().density;

        return (int) (size * scale + 0.5f);
    }

    public static int dpToPx(double size) {
        return dpToPx((float) size);
    }
}
