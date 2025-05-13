package com.iconshot.detonator.request;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.renderer.Edge;

public abstract class Request<T> {
    protected Detonator detonator;

    protected int id;
    protected Integer componentId;
    protected String data;

    public Request(Detonator detonator, IncomingRequest incomingRequest) {
        this.detonator = detonator;

        this.id = incomingRequest.id;
        this.componentId = incomingRequest.componentId;
        this.data = incomingRequest.data;
    }

    protected T decodeData(Class<T> DataClass) {
        if (data == null) {
            return null;
        }

        return detonator.decode(data, DataClass);
    }

    protected Edge getComponentEdge() {
        if (componentId == null) {
            return null;
        }

        return detonator.getEdge(componentId);
    }

    public abstract void run();

    protected void end() {
        end(null);
    }

    protected void end(Object data) {
        OutgoingResponse response = new OutgoingResponse();

        response.id = id;
        response.data = data;

        emit(response);
    }

    protected void error(Exception exception) {
        OutgoingResponse response = new OutgoingResponse();

        Error error = new Error();

        error.message = exception.getMessage();

        response.id = id;
        response.error = error;

        emit(response);
    }

    private void emit(OutgoingResponse response) {
        detonator.emit("response", response);
    }

    public static class IncomingRequest {
        public int id;
        public String name;
        public Integer componentId;
        public String data;
    }

    public static class OutgoingResponse {
        public int id;
        public Object data;
        public Error error;
    }

    public static class Error {
        public String message;
    }
}
