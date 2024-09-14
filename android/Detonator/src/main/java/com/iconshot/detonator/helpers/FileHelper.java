package com.iconshot.detonator.helpers;

import java.io.IOException;
import java.io.InputStream;
import java.util.Scanner;

public class FileHelper {
    public static String readFileFromAssets(String fileName) {
        StringBuilder stringBuilder = new StringBuilder();

        try (InputStream inputStream = ContextHelper.context.getAssets().open(fileName);
             Scanner scanner = new Scanner(inputStream)) {
            while (scanner.hasNextLine()) {
                stringBuilder.append(scanner.nextLine()).append("\n");
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return stringBuilder.toString();
    }
}
