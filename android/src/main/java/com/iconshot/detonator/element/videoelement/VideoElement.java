package com.iconshot.detonator.element.videoelement;

import android.net.Uri;
import android.os.Handler;
import android.view.View;

import androidx.media3.common.MediaItem;
import androidx.media3.common.MediaMetadata;
import androidx.media3.common.Player;
import androidx.media3.exoplayer.ExoPlayer;
import androidx.media3.ui.AspectRatioFrameLayout;
import androidx.media3.ui.PlayerView;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.Element;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;
import com.iconshot.detonator.layout.ViewLayout.LayoutParams;

public class VideoElement extends Element<VideoLayout, VideoElement.Attributes> {
    public ExoPlayer player;

    public PlayerView playerView;

    private final Handler handler = new Handler();
    private Runnable progressRunnable;

    private int currentPosition = 0;

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

        playerView = new PlayerView(ContextHelper.context);

        playerView.setUseController(false);

        startTrackingProgress(position -> {
            OnProgressData data = new OnProgressData();

            data.position = position;

            detonator.emitHandler("onProgress", edge.id, data);
        });

        playerView.setOnClickListener((View v) -> {
            view.callOnClick();
        });

        view.addView(playerView);

        return view;
    }

    @Override
    public void patchView() {
        String url = attributes.url;

        String currentUrl = currentAttributes != null ? currentAttributes.url : null;

        boolean patchUrl = forcePatch || !CompareHelper.compareObjects(url, currentUrl);

        if (patchUrl) {
            playerView.setAlpha(0);

            if (player != null) {
                player.release();
            }

            if (url != null) {
                player = new ExoPlayer.Builder(ContextHelper.context).build();

                player.addListener(new ExoPlayer.Listener() {
                    @Override
                    public void onPlaybackStateChanged(int playbackState) {
                        switch (playbackState) {
                            case ExoPlayer.STATE_READY: {
                                playerView.setAlpha(1);

                                break;
                            }

                            case ExoPlayer.STATE_ENDED: {
                                detonator.emitHandler("onEnd", edge.id);

                                break;
                            }


                        }
                    }
                });

                playerView.setPlayer(player);

                Uri uri = Uri.parse(url);

                MediaItem mediaItem = MediaItem.fromUri(uri);

                player.setMediaItem(mediaItem);

                player.prepare();
            } else {
                player = null;

                playerView.setPlayer(null);
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

    @androidx.media3.common.util.UnstableApi
    protected void patchObjectFit(String objectFit) {
        String tmpObjectFit = objectFit != null ? objectFit : "cover";

        switch (tmpObjectFit) {
            case "cover": {
                playerView.setResizeMode(AspectRatioFrameLayout.RESIZE_MODE_ZOOM);

                break;
            }

            case "contain": {
                playerView.setResizeMode(AspectRatioFrameLayout.RESIZE_MODE_FIT);

                break;
            }

            case "fill": {
                playerView.setResizeMode(AspectRatioFrameLayout.RESIZE_MODE_FILL);

                break;
            }
        }
    }

    @Override
    protected void removeView() {
        playerView.setPlayer(null);

        if (player != null) {
            player.release();
        }

        if (progressRunnable != null) {
            handler.removeCallbacks(progressRunnable);
        }
    }

    private void startTrackingProgress(OnProgressListener listener) {
        progressRunnable = new Runnable() {
            @Override
            public void run() {
                handler.postDelayed(this, 250);

                int position = player != null ? (int) player.getCurrentPosition() : 0;

                if (position == currentPosition) {
                    return;
                }

                currentPosition = position;

                listener.onProgress(position);
            }
        };

        handler.post(progressRunnable);
    }

    private static class OnProgressData {
        int position;
    }

    interface OnProgressListener {
        void onProgress(int position);
    }

    protected static class Attributes extends Element.Attributes {
        String url;
    }
}
