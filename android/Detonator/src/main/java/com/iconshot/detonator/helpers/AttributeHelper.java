package com.iconshot.detonator.helpers;

public class AttributeHelper {
    public static Float convertPercentStringToFloat(String percentString) {
        String numberString = percentString.replace("%", "")
                .replace("-", "");

        try {
            float value = Float.parseFloat(numberString);

            float percent = value / 100;

            return percentString.startsWith("-") ? percent * -1 : percent;
        } catch (Exception e) {
            return null;
        }
    }
}
