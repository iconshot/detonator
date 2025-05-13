package com.iconshot.detonator.request;

import android.graphics.Bitmap;
import android.os.AsyncTask;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ImageHelper;

import java.io.File;

public class ImageGetSizeRequest extends Request<String> {
    public ImageGetSizeRequest(Detonator detonator, IncomingRequest incomingRequest) {
        super(detonator, incomingRequest);
    }

    public void run() {
        String url = decodeData(String.class);

        class DownloadImageTask extends AsyncTask<String, Void, File> {
            @Override
            protected File doInBackground(String... urls) {
                String imageUrl = urls[0];

                Bitmap bitmap = ImageHelper.getBitmap(imageUrl);

                if (bitmap == null) {
                    return null;
                }

                File file = ImageHelper.getFile(imageUrl);

                return file;
            }

            @Override
            protected void onPostExecute(File file) {
                if (file == null) {
                    error(new Exception("Couldn't get image size."));

                    return;
                }

                ImageHelper.Size size = ImageHelper.getSize(file);

                end(size);
            }
        }

        Bitmap cachedBitmap = ImageHelper.getCachedBitmap(url);

        if (cachedBitmap == null) {
            new DownloadImageTask().execute(url);

            return;
        }

        File file = ImageHelper.getFile(url);

        ImageHelper.Size size = ImageHelper.getSize(file);

        end(size);
    }
}
