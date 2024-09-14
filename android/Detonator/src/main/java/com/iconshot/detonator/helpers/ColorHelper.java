package com.iconshot.detonator.helpers;

import android.graphics.Color;

import java.util.Map;
import java.util.HashMap;
import java.util.List;

public class ColorHelper {
    public static Integer parseColor(Object color) {
        if (color instanceof String) {
            String string = (String) color;

            if (string.equals("transparent")) {
                return null;
            }

            if (string.startsWith("#")) {
                return Color.parseColor(string);
            }

            if (!Colors.has(string)) {
                return null;
            }

            String hexCode = Colors.get(string);

            return Color.parseColor(hexCode);
        }

        if (color instanceof List) {
            List<Double> values = (List<Double>) color;

            int size = values.size();

            if (size != 3 && size != 4) {
                return null;
            }

            int red = values.get(0).intValue();
            int green = values.get(1).intValue();
            int blue = values.get(2).intValue();

            if (size == 3) {
                return Color.rgb(red, green, blue);
            }

            double alpha = values.get(3);

            return Color.argb((int) (alpha * 255), red, green, blue);
        }

        return null;
    }

    public static class Colors {
        private static final Map<String, String> map = new HashMap<String, String>();

        static {
            map.put("aliceblue", "#F0F8FF");
            map.put("antiquewhite", "#FAEBD7");
            map.put("aqua", "#00FFFF");
            map.put("aquamarine", "#7FFFD4");
            map.put("azure", "#F0FFFF");
            map.put("beige", "#F5F5DC");
            map.put("bisque", "#FFE4C4");
            map.put("black", "#000000");
            map.put("blanchedalmond", "#FFEBCD");
            map.put("blue", "#0000FF");
            map.put("blueviolet", "#8A2BE2");
            map.put("brown", "#A52A2A");
            map.put("burlywood", "#DEB887");
            map.put("cadetblue", "#5F9EA0");
            map.put("chartreuse", "#7FFF00");
            map.put("chocolate", "#D2691E");
            map.put("coral", "#FF7F50");
            map.put("cornflowerblue", "#6495ED");
            map.put("cornsilk", "#FFF8DC");
            map.put("crimson", "#DC143C");
            map.put("cyan", "#00FFFF");
            map.put("darkblue", "#00008B");
            map.put("darkcyan", "#008B8B");
            map.put("darkgoldenrod", "#B8860B");
            map.put("darkgray", "#A9A9A9");
            map.put("darkgreen", "#006400");
            map.put("darkgrey", "#A9A9A9");
            map.put("darkkhaki", "#BDB76B");
            map.put("darkmagenta", "#8B008B");
            map.put("darkolivegreen", "#556B2F");
            map.put("darkorange", "#FF8C00");
            map.put("darkorchid", "#9932CC");
            map.put("darkred", "#8B0000");
            map.put("darksalmon", "#E9967A");
            map.put("darkseagreen", "#8FBC8F");
            map.put("darkslateblue", "#483D8B");
            map.put("darkslategray", "#2F4F4F");
            map.put("darkslategrey", "#2F4F4F");
            map.put("darkturquoise", "#00CED1");
            map.put("darkviolet", "#9400D3");
            map.put("deeppink", "#FF1493");
            map.put("deepskyblue", "#00BFFF");
            map.put("dimgray", "#696969");
            map.put("dimgrey", "#696969");
            map.put("dodgerblue", "#1E90FF");
            map.put("firebrick", "#B22222");
            map.put("floralwhite", "#FFFAF0");
            map.put("forestgreen", "#228B22");
            map.put("fuchsia", "#FF00FF");
            map.put("gainsboro", "#DCDCDC");
            map.put("ghostwhite", "#F8F8FF");
            map.put("gold", "#FFD700");
            map.put("goldenrod", "#DAA520");
            map.put("gray", "#808080");
            map.put("green", "#008000");
            map.put("greenyellow", "#ADFF2F");
            map.put("grey", "#808080");
            map.put("honeydew", "#F0FFF0");
            map.put("hotpink", "#FF69B4");
            map.put("indianred", "#CD5C5C");
            map.put("indigo", "#4B0082");
            map.put("ivory", "#FFFFF0");
            map.put("khaki", "#F0E68C");
            map.put("lavender", "#E6E6FA");
            map.put("lavenderblush", "#FFF0F5");
            map.put("lawngreen", "#7CFC00");
            map.put("lemonchiffon", "#FFFACD");
            map.put("lightblue", "#ADD8E6");
            map.put("lightcoral", "#F08080");
            map.put("lightcyan", "#E0FFFF");
            map.put("lightgoldenrodyellow", "#FAFAD2");
            map.put("lightgray", "#D3D3D3");
            map.put("lightgreen", "#90EE90");
            map.put("lightgrey", "#D3D3D3");
            map.put("lightpink", "#FFB6C1");
            map.put("lightsalmon", "#FFA07A");
            map.put("lightseagreen", "#20B2AA");
            map.put("lightskyblue", "#87CEFA");
            map.put("lightslategray", "#778899");
            map.put("lightslategrey", "#778899");
            map.put("lightsteelblue", "#B0C4DE");
            map.put("lightyellow", "#FFFFE0");
            map.put("lime", "#00FF00");
            map.put("limegreen", "#32CD32");
            map.put("linen", "#FAF0E6");
            map.put("magenta", "#FF00FF");
            map.put("maroon", "#800000");
            map.put("mediumaquamarine", "#66CDAA");
            map.put("mediumblue", "#0000CD");
            map.put("mediumorchid", "#BA55D3");
            map.put("mediumpurple", "#9370DB");
            map.put("mediumseagreen", "#3CB371");
            map.put("mediumslateblue", "#7B68EE");
            map.put("mediumspringgreen", "#00FA9A");
            map.put("mediumturquoise", "#48D1CC");
            map.put("mediumvioletred", "#C71585");
            map.put("midnightblue", "#191970");
            map.put("mintcream", "#F5FFFA");
            map.put("mistyrose", "#FFE4E1");
            map.put("moccasin", "#FFE4B5");
            map.put("navajowhite", "#FFDEAD");
            map.put("navy", "#000080");
            map.put("oldlace", "#FDF5E6");
            map.put("olive", "#808000");
            map.put("olivedrab", "#6B8E23");
            map.put("orange", "#FFA500");
            map.put("orangered", "#FF4500");
            map.put("orchid", "#DA70D6");
            map.put("palegoldenrod", "#EEE8AA");
            map.put("palegreen", "#98FB98");
            map.put("paleturquoise", "#AFEEEE");
            map.put("palevioletred", "#DB7093");
            map.put("papayawhip", "#FFEFD5");
            map.put("peachpuff", "#FFDAB9");
            map.put("peru", "#CD853F");
            map.put("pink", "#FFC0CB");
            map.put("plum", "#DDA0DD");
            map.put("powderblue", "#B0E0E6");
            map.put("purple", "#800080");
            map.put("rebeccapurple", "#663399");
            map.put("red", "#FF0000");
            map.put("rosybrown", "#BC8F8F");
            map.put("royalblue", "#4169E1");
            map.put("saddlebrown", "#8B4513");
            map.put("salmon", "#FA8072");
            map.put("sandybrown", "#F4A460");
            map.put("seagreen", "#2E8B57");
            map.put("seashell", "#FFF5EE");
            map.put("sienna", "#A0522D");
            map.put("silver", "#C0C0C0");
            map.put("skyblue", "#87CEEB");
            map.put("slateblue", "#6A5ACD");
            map.put("slategray", "#708090");
            map.put("slategrey", "#708090");
            map.put("snow", "#FFFAFA");
            map.put("springgreen", "#00FF7F");
            map.put("steelblue", "#4682B4");
            map.put("tan", "#D2B48C");
            map.put("teal", "#008080");
            map.put("thistle", "#D8BFD8");
            map.put("tomato", "#FF6347");
            map.put("turquoise", "#40E0D0");
            map.put("violet", "#EE82EE");
            map.put("wheat", "#F5DEB3");
            map.put("white", "#FFFFFF");
            map.put("whitesmoke", "#F5F5F5");
            map.put("yellow", "#FFFF00");
            map.put("yellowgreen", "#9ACD32");
        }

        public static boolean has(String key) {
            return map.containsKey(key);
        }

        public static String get(String key) {
            return map.get(key);
        }
    }
}
