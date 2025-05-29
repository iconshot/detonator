package com.iconshot.detonator.module;

import android.util.Base64;

import com.iconshot.detonator.Detonator;

import java.io.File;
import java.io.RandomAccessFile;

public class FileStreamModule extends Module {
    public FileStreamModule(Detonator detonator) {
        super(detonator);
    }

    @Override
    public void register() {
        detonator.setMessageListener("com.iconshot.detonator.filestream.read::run", value -> {
            ReadData data = detonator.decode(value, ReadData.class);

            new Thread(() -> {
                String path = data.path.substring(7);

                File file = new File(path);

                try {
                    String base64 = readFileBase64Chunk(file, data.offset, data.size);

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

    private String readFileBase64Chunk(File file, int offset, int size) throws Exception {
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

    protected static class ReadData {
        int id;
        String path;
        int offset;
        int size;
    }
}
