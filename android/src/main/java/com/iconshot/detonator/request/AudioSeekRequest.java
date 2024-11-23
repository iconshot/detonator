package com.iconshot.detonator.request;

import androidx.media3.common.Player;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.AudioElement;
import com.iconshot.detonator.tree.Edge;

public class AudioSeekRequest extends Request<Integer> {
    public AudioSeekRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Integer position = decode(Integer.class);

        Edge edge = getComponentEdge();

        Edge audioEdge = edge.children.get(0);

        AudioElement element = (AudioElement) audioEdge.element;

        Player player = (Player) element.player;

        if (player != null) {
            player.seekTo(position);
        }

        end();
    }
}
