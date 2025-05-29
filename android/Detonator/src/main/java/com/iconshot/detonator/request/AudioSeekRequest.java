package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.element.AudioElement;
import com.iconshot.detonator.renderer.Edge;

public class AudioSeekRequest extends Request<Integer> {
    public AudioSeekRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Integer position = decodeData(Integer.class);

        Edge edge = getComponentEdge();

        AudioElement element = (AudioElement) edge.children.get(0).element;

        try {
            element.seek(position);

            end();
        } catch (Exception e) {
            error(e);
        }
    }
}
