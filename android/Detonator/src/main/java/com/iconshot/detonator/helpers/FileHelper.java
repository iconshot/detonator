package com.iconshot.detonator.helpers;

import android.content.Context;

import java.io.IOException;
import java.io.InputStream;
import java.util.Scanner;

public class FileHelper {
    public static String readFileFromAssets(Context context, String fileName) {
        StringBuilder stringBuilder = new StringBuilder();

        try (
                InputStream inputStream = context.getAssets().open(fileName);
                Scanner scanner = new Scanner(inputStream)
        ) {
            while (scanner.hasNextLine()) {
                stringBuilder.append(scanner.nextLine()).append("\n");
            }
        } catch (IOException e) {}

        return stringBuilder.toString();
    }
}
