package com.iconshot.detonator.element;

import android.net.Uri;
import android.os.Handler;
import android.view.View;

import androidx.media3.common.MediaItem;
import androidx.media3.exoplayer.ExoPlayer;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.CompareHelper;

public class AudioElement extends Element<View, AudioElement.Attributes> {
    private ExoPlayer player;

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
        View view = new View(detonator.context);

        startTrackingProgress();

        setRequestListener("com.iconshot.detonator.ui.audio::play", (promise, value) -> {
            if (player == null) {
                promise.reject("No player available.");

                return;
            }

            player.play();

            promise.resolve();
        });

        setRequestListener("com.iconshot.detonator.ui.audio::pause", (promise, value) -> {
            if (player == null) {
                promise.reject("No player available.");

                return;
            }

            player.pause();

            promise.resolve();
        });

        setRequestListener("com.iconshot.detonator.ui.audio::seek", (promise, value) -> {
            Integer position = detonator.decode(value, Integer.class);

            if (player == null) {
                promise.reject("No player available.");

                return;
            }

            player.seekTo(position);

            promise.resolve();
        });

        return view;
    }

    @Override
    public void patchView() {
        String source = attributes.source;

        String prevSource = prevAttributes != null ? prevAttributes.source : null;

        boolean patchSource = forcePatch || !CompareHelper.compareObjects(source, prevSource);

        if (patchSource) {
            patchSource(source);
        }

        Boolean muted = attributes.muted;

        Boolean prevMuted = prevAttributes != null ? prevAttributes.muted : null;

        boolean patchMuted = forcePatch || !CompareHelper.compareObjects(muted, prevMuted);

        if (patchMuted || patchSource) {
            if (player != null) {
                if (muted != null && muted) {
                    player.setVolume(0);
                } else {
                    player.setVolume(1);
                }
            }
        }
    }

    @Override
    protected void patchDisplay(String display) {
        super.patchDisplay("none");
    }

    private void patchSource(String source) {
        if (player != null) {
            player.release();
        }

        if (source == null) {
            player = null;

            return;
        }

        player = new ExoPlayer.Builder(detonator.context).build();

        player.addListener(new ExoPlayer.Listener() {
            @Override
            public void onPlaybackStateChanged(int playbackState) {
                switch (playbackState) {
                    case ExoPlayer.STATE_ENDED: {
                        sendHandler("onEnd");

                        break;
                    }
                }
            }
        });

        Uri uri = Uri.parse(source);

        MediaItem mediaItem = MediaItem.fromUri(uri);

        player.setMediaItem(mediaItem);

        player.prepare();

        sendHandler("onReady");
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

                sendHandler("onProgress", data);
            }
        };

        handler.post(progressRunnable);
    }

    private static class OnProgressData {
        int position;
    }

    protected static class Attributes extends Element.Attributes {
        String source;
        Boolean muted;
    }
}
