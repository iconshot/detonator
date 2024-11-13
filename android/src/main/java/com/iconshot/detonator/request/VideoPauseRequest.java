package com.iconshot.detonator.request;

import androidx.media3.common.Player;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.videoelement.VideoElement;
import com.iconshot.detonator.tree.Edge;

public class VideoPauseRequest extends Request {
    public VideoPauseRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        Edge videoEdge = edge.children.get(0);

        VideoElement element = (VideoElement) videoEdge.element;

        Player player = (Player) element.player;

        player.pause();

        end();
    }
}
