import UIKit

class ColorHelper {
    static func createColor(hexCode: String) -> UIColor? {
        var hex = hexCode.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        if hex.count == 6 {
            hex = "FF" + hex
        }
        
        guard hex.count == 8, let int = UInt64(hex, radix: 16) else {
            return nil
        }
        
        let a, r, g, b: UInt64
        
        (a, r, g, b) = (int >> 24, int >> 16 & 0xff, int >> 8 & 0xff, int & 0xff)
        
        let red = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue = CGFloat(b) / 255
        let alpha = CGFloat(a) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func parseColor(color: StyleColor) -> UIColor? {
        switch color {
        case .string(let string):
            if string == "transparent" {
                return nil
            }
            
            if string.hasPrefix("#") {
                return createColor(hexCode: string)
            }
            
            if let hexCode = Colors.get(string) {
                return createColor(hexCode: hexCode)
            }
            
            return nil
            
        case .array(let values):
            if values.count != 3 && values.count != 4 {
                return nil
            }
            
            let red = CGFloat(values[0]) / 255.0
            let green = CGFloat(values[1]) / 255.0
            let blue = CGFloat(values[2]) / 255.0
            
            let alpha = values.count == 4 ? CGFloat(values[3]) : 1.0
            
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

    class Colors {
        private static let map: [String: String] = {
            var map = [String: String]()
            
            map["aliceblue"] = "#F0F8FF"
            map["antiquewhite"] = "#FAEBD7"
            map["aqua"] = "#00FFFF"
            map["aquamarine"] = "#7FFFD4"
            map["azure"] = "#F0FFFF"
            map["beige"] = "#F5F5DC"
            map["bisque"] = "#FFE4C4"
            map["black"] = "#000000"
            map["blanchedalmond"] = "#FFEBCD"
            map["blue"] = "#0000FF"
            map["blueviolet"] = "#8A2BE2"
            map["brown"] = "#A52A2A"
            map["burlywood"] = "#DEB887"
            map["cadetblue"] = "#5F9EA0"
            map["chartreuse"] = "#7FFF00"
            map["chocolate"] = "#D2691E"
            map["coral"] = "#FF7F50"
            map["cornflowerblue"] = "#6495ED"
            map["cornsilk"] = "#FFF8DC"
            map["crimson"] = "#DC143C"
            map["cyan"] = "#00FFFF"
            map["darkblue"] = "#00008B"
            map["darkcyan"] = "#008B8B"
            map["darkgoldenrod"] = "#B8860B"
            map["darkgray"] = "#A9A9A9"
            map["darkgreen"] = "#006400"
            map["darkgrey"] = "#A9A9A9"
            map["darkkhaki"] = "#BDB76B"
            map["darkmagenta"] = "#8B008B"
            map["darkolivegreen"] = "#556B2F"
            map["darkorange"] = "#FF8C00"
            map["darkorchid"] = "#9932CC"
            map["darkred"] = "#8B0000"
            map["darksalmon"] = "#E9967A"
            map["darkseagreen"] = "#8FBC8F"
            map["darkslateblue"] = "#483D8B"
            map["darkslategray"] = "#2F4F4F"
            map["darkslategrey"] = "#2F4F4F"
            map["darkturquoise"] = "#00CED1"
            map["darkviolet"] = "#9400D3"
            map["deeppink"] = "#FF1493"
            map["deepskyblue"] = "#00BFFF"
            map["dimgray"] = "#696969"
            map["dimgrey"] = "#696969"
            map["dodgerblue"] = "#1E90FF"
            map["firebrick"] = "#B22222"
            map["floralwhite"] = "#FFFAF0"
            map["forestgreen"] = "#228B22"
            map["fuchsia"] = "#FF00FF"
            map["gainsboro"] = "#DCDCDC"
            map["ghostwhite"] = "#F8F8FF"
            map["gold"] = "#FFD700"
            map["goldenrod"] = "#DAA520"
            map["gray"] = "#808080"
            map["green"] = "#008000"
            map["greenyellow"] = "#ADFF2F"
            map["grey"] = "#808080"
            map["honeydew"] = "#F0FFF0"
            map["hotpink"] = "#FF69B4"
            map["indianred"] = "#CD5C5C"
            map["indigo"] = "#4B0082"
            map["ivory"] = "#FFFFF0"
            map["khaki"] = "#F0E68C"
            map["lavender"] = "#E6E6FA"
            map["lavenderblush"] = "#FFF0F5"
            map["lawngreen"] = "#7CFC00"
            map["lemonchiffon"] = "#FFFACD"
            map["lightblue"] = "#ADD8E6"
            map["lightcoral"] = "#F08080"
            map["lightcyan"] = "#E0FFFF"
            map["lightgoldenrodyellow"] = "#FAFAD2"
            map["lightgray"] = "#D3D3D3"
            map["lightgreen"] = "#90EE90"
            map["lightgrey"] = "#D3D3D3"
            map["lightpink"] = "#FFB6C1"
            map["lightsalmon"] = "#FFA07A"
            map["lightseagreen"] = "#20B2AA"
            map["lightskyblue"] = "#87CEFA"
            map["lightslategray"] = "#778899"
            map["lightslategrey"] = "#778899"
            map["lightsteelblue"] = "#B0C4DE"
            map["lightyellow"] = "#FFFFE0"
            map["lime"] = "#00FF00"
            map["limegreen"] = "#32CD32"
            map["linen"] = "#FAF0E6"
            map["magenta"] = "#FF00FF"
            map["maroon"] = "#800000"
            map["mediumaquamarine"] = "#66CDAA"
            map["mediumblue"] = "#0000CD"
            map["mediumorchid"] = "#BA55D3"
            map["mediumpurple"] = "#9370DB"
            map["mediumseagreen"] = "#3CB371"
            map["mediumslateblue"] = "#7B68EE"
            map["mediumspringgreen"] = "#00FA9A"
            map["mediumturquoise"] = "#48D1CC"
            map["mediumvioletred"] = "#C71585"
            map["midnightblue"] = "#191970"
            map["mintcream"] = "#F5FFFA"
            map["mistyrose"] = "#FFE4E1"
            map["moccasin"] = "#FFE4B5"
            map["navajowhite"] = "#FFDEAD"
            map["navy"] = "#000080"
            map["oldlace"] = "#FDF5E6"
            map["olive"] = "#808000"
            map["olivedrab"] = "#6B8E23"
            map["orange"] = "#FFA500"
            map["orangered"] = "#FF4500"
            map["orchid"] = "#DA70D6"
            map["palegoldenrod"] = "#EEE8AA"
            map["palegreen"] = "#98FB98"
            map["paleturquoise"] = "#AFEEEE"
            map["palevioletred"] = "#DB7093"
            map["papayawhip"] = "#FFEFD5"
            map["peachpuff"] = "#FFDAB9"
            map["peru"] = "#CD853F"
            map["pink"] = "#FFC0CB"
            map["plum"] = "#DDA0DD"
            map["powderblue"] = "#B0E0E6"
            map["purple"] = "#800080"
            map["rebeccapurple"] = "#663399"
            map["red"] = "#FF0000"
            map["rosybrown"] = "#BC8F8F"
            map["royalblue"] = "#4169E1"
            map["saddlebrown"] = "#8B4513"
            map["salmon"] = "#FA8072"
            map["sandybrown"] = "#F4A460"
            map["seagreen"] = "#2E8B57"
            map["seashell"] = "#FFF5EE"
            map["sienna"] = "#A0522D"
            map["silver"] = "#C0C0C0"
            map["skyblue"] = "#87CEEB"
            map["slateblue"] = "#6A5ACD"
            map["slategray"] = "#708090"
            map["slategrey"] = "#708090"
            map["snow"] = "#FFFAFA"
            map["springgreen"] = "#00FF7F"
            map["steelblue"] = "#4682B4"
            map["tan"] = "#D2B48C"
            map["teal"] = "#008080"
            map["thistle"] = "#D8BFD8"
            map["tomato"] = "#FF6347"
            map["turquoise"] = "#40E0D0"
            map["violet"] = "#EE82EE"
            map["wheat"] = "#F5DEB3"
            map["white"] = "#FFFFFF"
            map["whitesmoke"] = "#F5F5F5"
            map["yellow"] = "#FFFF00"
            map["yellowgreen"] = "#9ACD32"
            
            return map
        }()

        static func has(_ key: String) -> Bool {
            return map[key] != nil
        }

        static func get(_ key: String) -> String? {
            return map[key]
        }
    }
}
