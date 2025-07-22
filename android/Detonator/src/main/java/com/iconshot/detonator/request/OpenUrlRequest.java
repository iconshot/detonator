package com.iconshot.detonator.request;

import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;

import com.iconshot.detonator.Detonator;

public class OpenUrlRequest extends Request<String> {
    public OpenUrlRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    @Override
    public void run() {
        String url = decodeData(String.class);

        try {
            Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(url));

            detonator.context.startActivity(browserIntent);

            end();
        } catch (ActivityNotFoundException e) {
            error(new Exception("Can't open url."));
        }
    }
}
