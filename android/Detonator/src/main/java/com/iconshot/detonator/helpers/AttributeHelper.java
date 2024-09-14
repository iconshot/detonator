package com.iconshot.detonator.helpers;

public class AttributeHelper {
    public static Float convertPercentStringToFloat(String percentString) {
        String numberString = percentString.replace("%", "");

        try {
            float value = Float.parseFloat(numberString);

            return value / 100;
        } catch (Exception e) {
            return null;
        }
    }
}
