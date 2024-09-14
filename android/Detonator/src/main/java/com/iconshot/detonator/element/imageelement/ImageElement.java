package com.iconshot.detonator.element.imageelement;

import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.widget.ImageView;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.ImageHelper;
import com.iconshot.detonator.layout.ViewLayout.LayoutParams;

public class ImageElement extends Element<CustomImageView, ImageElement.Attributes> {
    public ImageElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    public CustomImageView createView() {
        return new CustomImageView(ContextHelper.context);
    }

    @Override
    public void patchView() {
        String url = attributes.url;

        String currentUrl = currentAttributes != null ? currentAttributes.url : null;

        boolean patchUrl = forcePatch || !CompareHelper.compareObjects(url, currentUrl);

        if (patchUrl) {
            patchUrl(url);
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

    protected void patchObjectFit(String objectFit) {
        String tmpObjectFit = objectFit != null ? objectFit : "cover";

        switch (tmpObjectFit) {
            case "cover": {
                view.setScaleType(ImageView.ScaleType.CENTER_CROP);

                break;
            }

            case "contain": {
                view.setScaleType(ImageView.ScaleType.CENTER_INSIDE);

                break;
            }

            case "fill": {
                view.setScaleType(ImageView.ScaleType.FIT_XY);

                break;
            }
        }
    }

    private void patchUrl(String url) {
        if (url == null) {
            view.setImageBitmap(null);

            return;
        }

        class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
            @Override
            protected Bitmap doInBackground(String... urls) {
                String imageUrl = urls[0];

                Bitmap bitmap = ImageHelper.getBitmap(imageUrl);

                return bitmap;
            }

            @Override
            protected void onPostExecute(Bitmap result) {
                if (result != null) {
                    view.setImageBitmap(result);
                } else {
                    // Handle error or display placeholder image
                }
            }
        }

        Bitmap cachedBitmap = ImageHelper.getCachedBitmap(url);

        if (cachedBitmap == null) {
            // Image not found in cache, download it

            new DownloadImageTask().execute(url);

            return;
        }

        // Image found in cache, load it

        view.setImageBitmap(cachedBitmap);
    }

    protected static class Attributes extends Element.Attributes {
        String url;
    }
}
