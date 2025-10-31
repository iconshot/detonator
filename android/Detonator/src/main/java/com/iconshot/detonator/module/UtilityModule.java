package com.iconshot.detonator.module;

import android.content.ActivityNotFoundException;
import android.content.ContentResolver;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.widget.Toast;

import com.iconshot.detonator.Detonator;
import com.iconshot.detonator.helpers.ImageHelper;

import java.io.File;
import java.io.InputStream;

public class UtilityModule extends Module {
    public UtilityModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void setUp() {
        detonator.setEventListener("com.iconshot.detonator::log", value -> {
            String str = value.substring(1, value.length() - 1);

            System.out.println(str);
        });

        detonator.setRequestListener("com.iconshot.detonator::openUrl", (promise, value, edge) -> {
            try {
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(value));

                detonator.context.startActivity(browserIntent);

                promise.resolve();
            } catch (ActivityNotFoundException e) {
                promise.reject("Can't open url.");
            }
        });

        detonator.setRequestListener("com.iconshot.detonator.imagesize::getSize", (promise, value, edge) -> {
            String source = value;

            if (source.startsWith("file://")) {
                String path = source.substring(7);

                File file = new File(path);

                if (!file.exists()) {
                    promise.reject("File does not exist.");

                    return;
                }

                ImageHelper.Size size = ImageHelper.getSize(file);

                promise.resolve(size);

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

                    promise.resolve(size);
                } catch (Exception e) {
                    promise.reject("Unable to get size.");
                }

                return;
            }

            Bitmap cachedBitmap = ImageHelper.getCachedBitmap(detonator.context, source);

            if (cachedBitmap != null) {
                File file = ImageHelper.getFile(detonator.context, source);

                System.out.println(file);

                ImageHelper.Size size = ImageHelper.getSize(file);

                promise.resolve(size);

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
                        promise.reject("Couldn't get image size.");

                        return;
                    }

                    ImageHelper.Size size = ImageHelper.getSize(file);

                    promise.resolve(size);
                }
            }

            new DownloadImageTask().execute(source);
        });

        detonator.setRequestListener("com.iconshot.detonator.toast::show", (promise, value, edge) -> {
            ShowToastData data = detonator.decode(value, ShowToastData.class);

            int duration = data.isShort ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG;

            Toast.makeText(detonator.context, data.text, duration).show();

            promise.resolve();
        });
    }

    private static class ShowToastData {
        String text;
        boolean isShort;
    }
}
