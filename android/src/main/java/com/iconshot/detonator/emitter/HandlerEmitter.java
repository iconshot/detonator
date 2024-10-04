package com.iconshot.detonator.emitter;

import com.iconshot.detonator.Detonator;

public class HandlerEmitter extends Emitter {
    public HandlerEmitter(Detonator detonator) {
        super(detonator);
    }

    public void emit(String name, int edgeId, Object data) {
        Handler handler = new Handler();

        handler.name = name;
        handler.edgeId = edgeId;
        handler.data = data;

        detonator.emit("handler", handler);
    }

    private static class Handler {
        String name;
        int edgeId;
        Object data;
    }
}
