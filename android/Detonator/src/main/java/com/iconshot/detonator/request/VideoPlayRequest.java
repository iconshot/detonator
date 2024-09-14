package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.videoelement.CustomVideoView;
import com.iconshot.detonator.element.videoelement.VideoElement;
import com.iconshot.detonator.tree.Edge;

public class VideoPlayRequest extends Request {
    public VideoPlayRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        Edge videoEdge = edge.children.get(0);

        VideoElement element = (VideoElement) videoEdge.element;

        CustomVideoView videoView = (CustomVideoView) element.videoView;

        videoView.start();

        end();
    }
}
