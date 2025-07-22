package com.iconshot.detonator.module;

import android.content.ContentResolver;
import android.net.Uri;
import android.util.Base64;

import com.iconshot.detonator.Detonator;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.util.HashMap;
import java.util.Map;

public class FileStreamModule extends Module {
    private Map<Integer, InputStream> streams = new HashMap<>();

    public FileStreamModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void setUp() {
        detonator.setMessageListener("com.iconshot.detonator.filestream.read::run", value -> {
            ReadData data = detonator.decode(value, ReadData.class);

            new Thread(() -> {
                try {
                    String base64 = "";

                    if (data.path.startsWith("file://")) {
                        base64 = readFileBase64ChunkFromFile(data.id, data.path, data.offset, data.size);
                    } else if (data.path.startsWith("content://")) {
                        base64 = readFileBase64ChunkFromContent(data.id, data.path, data.offset, data.size);
                    } else {
                        throw new Exception("Unsupported path.");
                    }

                    String dataValue = data.id + "\n" + base64;

                    detonator.uiHandler.post(() -> {
                        detonator.emit("com.iconshot.detonator.filestream.read.data", dataValue);
                    });
                } catch (Exception exception) {
                    String errorValue = data.id + "\n" + exception.getMessage();

                    detonator.uiHandler.post(() -> {
                        detonator.emit("com.iconshot.detonator.filestream.read.error", errorValue);
                    });
                }
            }).start();
        });
    }

    private String readFileBase64ChunkFromFile(int id, String path, int offset, int size) throws Exception {
        File file = new File(path.replace("file://", ""));

        try (RandomAccessFile raf = new RandomAccessFile(file, "r")) {
            if (offset >= raf.length()) {
                return "";
            }

            raf.seek(offset);

            byte[] buffer = new byte[size];

            int bytesRead = raf.read(buffer);

            byte[] chunk = bytesRead == buffer.length
                    ? buffer
                    : java.util.Arrays.copyOf(buffer, bytesRead);

            String base64 = Base64.encodeToString(chunk, Base64.NO_WRAP);

            return base64;
        }
    }

    private String readFileBase64ChunkFromContent(int id, String path, int offset, int size) throws Exception {
        ContentResolver contentResolver = detonator.context.getContentResolver();

        InputStream stream = streams.get(id);

        if (stream == null) {
            Uri uri = Uri.parse(path);

            InputStream tmpStream = contentResolver.openInputStream(uri);

            if (tmpStream == null) {
                throw new Exception("Cannot open stream.");
            }

            stream = new BufferedInputStream(tmpStream, size);

            streams.put(id, stream);
        }

        byte[] buffer = new byte[size];

        int bytesRead = stream.read(buffer);

        if (bytesRead == -1) {
            stream.close();

            streams.remove(id);

            return "";
        }

        byte[] chunk = bytesRead == buffer.length
                ? buffer
                : java.util.Arrays.copyOf(buffer, bytesRead);

        return Base64.encodeToString(chunk, Base64.NO_WRAP);
    }

    protected static class ReadData {
        int id;
        String path;
        int offset;
        int size;
    }
}
