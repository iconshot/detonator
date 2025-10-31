package com.iconshot.detonator;

import java.util.List;
import java.util.Arrays;

public class MessageFormatter {
    private Detonator detonator;

    private static final String delimiter = "\u0000";

    public MessageFormatter(Detonator detonator) {
        this.detonator = detonator;
    }

    public String join(List<Object> lines) {
        StringBuilder sb = new StringBuilder();

        for (int i = 0; i < lines.size(); i++) {
            Object line = lines.get(i);

            if (i > 0) {
                sb.append(delimiter);
            }

            if (line instanceof String) {
                sb.append((String) line);
            } else {
                sb.append(detonator.encode(line));
            }
        }

        return sb.toString();
    }

    public List<String> split(String value) {
        return split(value, 0);
    }

    public List<String> split(String value, int limit) {
        String[] parts = limit > 0 ?
                value.split(delimiter, limit)
                : value.split(delimiter, -1);

        return Arrays.asList(parts);
    }
}