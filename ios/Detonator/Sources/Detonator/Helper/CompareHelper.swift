class CompareHelper {
    public static func compareStyleSizes(_ a: StyleSize?, _ b: StyleSize?) -> Bool {
        if a == nil {
            return b == nil
        }
        
        switch a {
        case .float(let aFloat):
            switch b {
            case .float(let bFloat):
                return aFloat == bFloat
                
            default:
                return false
            }
            
        case .string(let aString):
            switch b {
            case .string(let bString):
                return aString == bString
                
            default:
                return false
            }
            
        default:
            return false
        }
    }
    
    public static func compareStyleColors(_ a: StyleColor?, _ b: StyleColor?) -> Bool {
        if a == nil {
            return b == nil
        }
        
        switch a {
        case .string(let aString):
            switch b {
            case .string(let bString):
                return aString == bString
            
            default:
                return false
            }
            
        case .array(let aArray):
            switch b {
            case .array(let bArray):
                if aArray.count != bArray.count {
                    return false
                }
                
                for (i, aFloat) in aArray.enumerated() {
                    let bFloat = bArray[i]
                    
                    if aFloat != bFloat {
                        return false
                    }
                }
                
                return true
                
            default:
                return false
            }
            
        default:
            return false
        }
    }
}
