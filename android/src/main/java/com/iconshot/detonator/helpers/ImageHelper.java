package com.iconshot.detonator.helpers;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class ImageHelper {
    static public Bitmap getBitmap(String imageUrl) {
        Bitmap bitmap = null;

        try {
            URL url = new URL(imageUrl);

            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            connection.setDoInput(true);
            connection.connect();

            InputStream input = connection.getInputStream();

            bitmap = BitmapFactory.decodeStream(input);

            if (bitmap != null) {
                cacheBitmap(bitmap, imageUrl);
            }
        } catch (IOException e) {}

        return bitmap;
    }

    static public Bitmap getCachedBitmap(String imageUrl) {
        File file = getFile(imageUrl);

        if (file.exists()) {
            try {
                FileInputStream fis = new FileInputStream(file);

                Bitmap bitmap = BitmapFactory.decodeStream(fis);

                fis.close();

                return bitmap;
            } catch (IOException e) {}
        }

        return null;
    }

    static public void cacheBitmap(Bitmap bitmap, String imageUrl) {
        File file = getFile(imageUrl);

        File parent = file.getParentFile();

        if (!parent.exists()) {
            parent.mkdirs();
        }

        try {
            FileOutputStream fos = new FileOutputStream(file);

            bitmap.compress(Bitmap.CompressFormat.PNG, 100, fos);

            fos.flush();
            fos.close();
        } catch (IOException e) { }
    }

    static public File getFile(String imageUrl) {
        String fileName = getFileName(imageUrl);

        File directory = new File(ContextHelper.context.getCacheDir(), "com.iconshot.detonator.image");

        File file = new File(directory, fileName);

        return file;
    }

    static public String getFileName(String imageUrl) {
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");

            digest.update(imageUrl.getBytes());

            byte[] hash = digest.digest();

            StringBuilder hexString = new StringBuilder();

            for (byte b : hash) {
                String hex = Integer.toHexString(0xFF & b);

                if (hex.length() == 1) {
                    hexString.append('0');
                }

                hexString.append(hex);
            }

            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            // Fall back to using URL as filename if MD5 algorithm is not available

            return imageUrl.substring(imageUrl.lastIndexOf('/') + 1);
        }
    }

    static public Size getSize(File file) {
        BitmapFactory.Options options = new BitmapFactory.Options();

        options.inJustDecodeBounds = true;

        BitmapFactory.decodeFile(file.getAbsolutePath(), options);

        Size size = new Size();

        size.width = options.outWidth;
        size.height = options.outHeight;

        return size;
    }

    static public class Size {
        int width;
        int height;
    }
}