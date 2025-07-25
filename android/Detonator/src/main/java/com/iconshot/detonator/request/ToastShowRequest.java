package com.iconshot.detonator.request;

import android.widget.Toast;

import com.iconshot.detonator.Detonator;

public class ToastShowRequest extends Request<ToastShowRequest.Data> {
    public ToastShowRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        Data data = decodeData(Data.class);

        int duration = data.isShort ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG;

        Toast.makeText(detonator.context, data.text, duration).show();

        end(null);
    }

    public static class Data {
        String text;
        boolean isShort;
    }
}
