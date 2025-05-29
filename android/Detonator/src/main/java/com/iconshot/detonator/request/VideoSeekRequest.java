package com.iconshot.detonator.request;

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

        VideoElement element = (VideoElement) edge.children.get(0).element;

        try {
            element.seek(position);

            end();
        } catch (Exception e) {
            error(e);
        }
    }
}
