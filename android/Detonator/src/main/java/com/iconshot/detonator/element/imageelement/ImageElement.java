package com.iconshot.detonator.element.imageelement;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.widget.ImageView;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.helpers.ImageHelper;
import com.iconshot.detonator.layout.ViewLayout.LayoutParams;

import java.io.File;

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
        String source = attributes.source;

        String prevSource = prevAttributes != null ? prevAttributes.source : null;

        boolean patchSource = forcePatch || !CompareHelper.compareObjects(source, prevSource);

        if (patchSource) {
            patchSource(source);
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

    private void patchSource(String source) {
        if (source == null) {
            view.setImageBitmap(null);

            return;
        }

        if (source.startsWith("file://")) {
            String path = source.substring(7);

            File file = new File(path);

            Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());

            view.setImageBitmap(bitmap);

            return;
        }

        Bitmap cachedBitmap = ImageHelper.getCachedBitmap(source);

        // image found in cache, load it

        if (cachedBitmap != null) {
            view.setImageBitmap(cachedBitmap);

            return;
        }

        // image not found in cache, download it

        class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
            @Override
            protected Bitmap doInBackground(String... urls) {
                String imageUrl = urls[0];

                Bitmap bitmap = ImageHelper.loadImageBitmap(imageUrl);

                return bitmap;
            }

            @Override
            protected void onPostExecute(Bitmap bitmap) {
                view.setImageBitmap(bitmap);
            }
        }

        new DownloadImageTask().execute(source);
    }

    protected static class Attributes extends Element.Attributes {
        String source;
    }
}
