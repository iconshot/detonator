package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.AudioElement;
import com.iconshot.detonator.renderer.Edge;

public class AudioPlayRequest extends Request {
    public AudioPlayRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Edge edge = getComponentEdge();

        AudioElement element = (AudioElement) edge.children.get(0).element;

        try {
            element.play();

            end();
        } catch (Exception e) {
            error(e);
        }
    }
}
