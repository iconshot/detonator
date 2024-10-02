package com.iconshot.detonator.element.videoelement;

import android.net.Uri;
import android.view.View;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.layout.ViewLayout.LayoutParams;

public class VideoElement extends Element<VideoLayout, VideoElement.Attributes> {
    public CustomVideoView videoView;

    public VideoElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    public VideoLayout createView() {
        VideoLayout view = new VideoLayout(ContextHelper.context);

        videoView = new CustomVideoView(ContextHelper.context);

        videoView.setOnPreparedListener(view::setMediaPlayer);

        videoView.setOnClickListener((View v) -> {
            view.callOnClick();
        });

        view.addView(videoView);

        return view;
    }

    @Override
    public void patchView() {
        String url = attributes.url;

        String currentUrl = currentAttributes != null ? currentAttributes.url : null;

        boolean patchUrl = forcePatch || !CompareHelper.compareObjects(url, currentUrl);

        if (patchUrl) {
            if (url != null) {
                videoView.setVideoURI(Uri.parse(url));
            } else {
                videoView.stopPlayback();

                videoView.setVideoURI(null);
            }
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
                view.setObjectFit(VideoLayout.OBJECT_FIT_COVER);

                break;
            }

            case "contain": {
                view.setObjectFit(VideoLayout.OBJECT_FIT_CONTAIN);

                break;
            }

            case "fill": {
                view.setObjectFit(VideoLayout.OBJECT_FIT_FILL);

                break;
            }
        }
    }

    protected static class Attributes extends Element.Attributes {
        String url;
    }
}
