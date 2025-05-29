package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.videoelement.VideoElement;
import com.iconshot.detonator.renderer.Edge;

public class VideoPauseRequest extends Request {
    public VideoPauseRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        VideoElement element = (VideoElement) edge.children.get(0).element;

        try {
            element.pause();

            end();
        } catch (Exception e) {
            error(e);
        }
    }
}
