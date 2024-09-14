package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.videoelement.CustomVideoView;
import com.iconshot.detonator.element.videoelement.VideoElement;
import com.iconshot.detonator.tree.Edge;

public class VideoSeekRequest extends Request<Integer> {
    public VideoSeekRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Integer time = decode(Integer.class);

        Edge edge = getComponentEdge();

        Edge videoEdge = edge.children.get(0);

        VideoElement element = (VideoElement) videoEdge.element;

        CustomVideoView videoView = (CustomVideoView) element.videoView;

        videoView.seekTo(time);

        end();
    }
}
