package com.iconshot.detonator;

import java.util.ArrayList;
import java.util.List;

public class RequestPromise {
    private Detonator detonator;
    private int fetchId;

    public RequestPromise(Detonator detonator, int fetchId) {
        this.detonator = detonator;
        this.fetchId = fetchId;
    }

    public void resolve() {
        resolve("");
    }

    public void resolve(Object data) {
        List<Object> lines = new ArrayList();

        lines.add(String.valueOf(fetchId));
        lines.add(data);

        String value = detonator.messageFormatter.join(lines);

        detonator.uiHandler.post(() -> {
            detonator.send("com.iconshot.detonator.request.fetch::resolve", value);
        });
    }

    public void reject(Exception exception) {
        reject(exception.getMessage());
    }

    public void reject(String message) {
        List<Object> lines = new ArrayList();

        lines.add(String.valueOf(fetchId));
        lines.add(message);

        String value = detonator.messageFormatter.join(lines);

        detonator.uiHandler.post(() -> {
            detonator.send("com.iconshot.detonator.request.fetch::reject", value);
        });
    }
}