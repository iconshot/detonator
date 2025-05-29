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
        String source = decodeData(String.class);

        if (source.startsWith("file://")) {
            String path = source.substring(7);

            File file = new File(path);

            if (!file.exists()) {
                error(new Exception("File does not exist."));

                return;
            }

            ImageHelper.Size size = ImageHelper.getSize(file);

            end(size);

            return;
        }

        Bitmap cachedBitmap = ImageHelper.getCachedBitmap(source);

        if (cachedBitmap != null) {
            File file = ImageHelper.getFile(source);

            ImageHelper.Size size = ImageHelper.getSize(file);

            end(size);

            return;
        }

        class DownloadImageTask extends AsyncTask<String, Void, File> {
            @Override
            protected File doInBackground(String... urls) {
                String imageUrl = urls[0];

                Bitmap bitmap = ImageHelper.loadImageBitmap(imageUrl);

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

        new DownloadImageTask().execute(source);
    }
}
