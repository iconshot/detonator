package com.iconshot.detonator.helpers;

import java.util.List;

public class CompareHelper {
    public static boolean compareObjects(Object a, Object b) {
        if (a == null) {
            return b == null;
        }

        return a.equals(b);
    }

    public static boolean compareColors(Object a, Object b) {
        if (a == null) {
            return b == null;
        }

        if (a instanceof String) {
            return a.equals(b);
        }

        if (a instanceof List) {
            if (!(b instanceof List)) {
                return false;
            }

            List<Double> aList = (List<Double>) a;
            List<Double> bList = (List<Double>) b;

            if (aList.size() != bList.size()) {
                return false;
            }

            int i = 0;

            for (Double aDouble : aList) {
                Double bDouble = bList.get(i);

                if (!CompareHelper.compareObjects(aDouble, bDouble)) {
                    return false;
                }

                i++;
            }

            return true;
        }

        return false;
    }

    public static <T> boolean compareLists(List<T> a, List<T> b) {
        if (a == null) {
            return b == null;
        }

        if (a.size() != b.size()) {
            return false;
        }

        int i = 0;

        for (T aValue : a) {
            T bValue = b.get(i);

            if (!CompareHelper.compareObjects(aValue, bValue)) {
                return false;
            }

            i++;
        }

        return true;
    }
}
