package com.iconshot.detonator.emitter;

import com.iconshot.detonator.Detonator;

public class EventEmitter extends Emitter {
    public EventEmitter(Detonator detonator) {
        super(detonator);
    }

    public void emit(String name) {
        emit(name, null);
    }

    public void emit(String name, Object data) {
        Event handler = new Event();

        handler.name = name;
        handler.data = data;

        detonator.emit("event", handler);
    }

    private static class Event {
        String name;
        Object data;
    }
}
