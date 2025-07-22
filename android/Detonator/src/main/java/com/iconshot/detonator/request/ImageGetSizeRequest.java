package com.iconshot.detonator.request;

import android.content.ContentResolver;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ImageHelper;

import java.io.File;
import java.io.InputStream;

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

        if (source.startsWith("content://")) {
            Uri uri = Uri.parse(source);

            ContentResolver contentResolver = detonator.context.getContentResolver();

            BitmapFactory.Options options = new BitmapFactory.Options();

            options.inJustDecodeBounds = true;

            try (InputStream input = contentResolver.openInputStream(uri)) {
                BitmapFactory.decodeStream(input, null, options);

                int width = options.outWidth;
                int height = options.outHeight;

                ImageHelper.Size size = new ImageHelper.Size();

                size.width = width;
                size.height = height;

                end(size);
            } catch (Exception e) {
                error(new Exception("Unable to get size."));
            }

            return;
        }

        Bitmap cachedBitmap = ImageHelper.getCachedBitmap(detonator.context, source);

        if (cachedBitmap != null) {
            File file = ImageHelper.getFile(detonator.context, source);

            ImageHelper.Size size = ImageHelper.getSize(file);

            end(size);

            return;
        }

        class DownloadImageTask extends AsyncTask<String, Void, File> {
            @Override
            protected File doInBackground(String... urls) {
                String imageUrl = urls[0];

                Bitmap bitmap = ImageHelper.loadImageBitmap(detonator.context, imageUrl);

                if (bitmap == null) {
                    return null;
                }

                File file = ImageHelper.getFile(detonator.context, imageUrl);

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
