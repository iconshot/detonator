package com.iconshot.detonator.request;

import androidx.media3.common.Player;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.videoelement.VideoElement;
import com.iconshot.detonator.renderer.Edge;

public class VideoSeekRequest extends Request<Integer> {
    public VideoSeekRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Integer position = decodeData(Integer.class);

        Edge edge = getComponentEdge();

        Edge videoEdge = edge.children.get(0);

        VideoElement element = (VideoElement) videoEdge.element;

        Player player = (Player) element.player;

        if (player != null) {
            player.seekTo(position);
        }

        end();
    }
}
