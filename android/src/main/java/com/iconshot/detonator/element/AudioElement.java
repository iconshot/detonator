package com.iconshot.detonator.element;

import android.net.Uri;
import android.os.Handler;
import android.view.View;

import androidx.media3.common.MediaItem;
import androidx.media3.exoplayer.ExoPlayer;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.CompareHelper;
import com.iconshot.detonator.helpers.ContextHelper;

public class AudioElement extends Element<View, AudioElement.Attributes> {
    public ExoPlayer player;

    private final Handler handler = new Handler();
    private Runnable progressRunnable;

    private int currentPosition = 0;

    public AudioElement(Detonator detonator) {
        super(detonator);
    }

    @Override
    public Class<Attributes> getAttributesClass() {
        return Attributes.class;
    }

    @Override
    public View createView() {
        View view = new View(ContextHelper.context);

        startTrackingProgress();

        return view;
    }

    @Override
    public void patchView() {
        String url = attributes.url;

        String currentUrl = currentAttributes != null ? currentAttributes.url : null;

        boolean patchUrl = forcePatch || !CompareHelper.compareObjects(url, currentUrl);

        if (patchUrl) {
            patchUrl(url);
        }

        Boolean muted = attributes.muted;

        Boolean currentMuted = currentAttributes != null ? currentAttributes.muted : null;

        boolean patchMuted = forcePatch || !CompareHelper.compareObjects(muted, currentMuted);

        if (patchMuted || patchUrl) {
            if (player != null) {
                if (muted != null && muted) {
                    player.setVolume(0);
                } else {
                    player.setVolume(1);
                }
            }
        }
    }

    private void patchUrl(String url) {
        if (player != null) {
            player.release();
        }

        if (url != null) {
            player = new ExoPlayer.Builder(ContextHelper.context).build();

            player.addListener(new ExoPlayer.Listener() {
                @Override
                public void onPlaybackStateChanged(int playbackState) {
                    switch (playbackState) {
                        case ExoPlayer.STATE_ENDED: {
                            detonator.emitHandler("onEnd", edge.id);

                            break;
                        }
                    }
                }
            });

            Uri uri = Uri.parse(url);

            MediaItem mediaItem = MediaItem.fromUri(uri);

            player.setMediaItem(mediaItem);

            player.prepare();
        } else {
            player = null;
        }
    }

    @Override
    protected void removeView() {
        if (player != null) {
            player.release();
        }

        if (progressRunnable != null) {
            handler.removeCallbacks(progressRunnable);
        }
    }

    private void startTrackingProgress() {
        progressRunnable = new Runnable() {
            @Override
            public void run() {
                handler.postDelayed(this, 1000 / 30);

                int position = player != null ? (int) player.getCurrentPosition() : 0;

                if (position == currentPosition) {
                    return;
                }

                currentPosition = position;

                OnProgressData data = new OnProgressData();

                data.position = position;

                detonator.emitHandler("onProgress", edge.id, data);
            }
        };

        handler.post(progressRunnable);
    }

    private static class OnProgressData {
        int position;
    }

    protected static class Attributes extends Element.Attributes {
        String url;
        Boolean muted;
    }
}
