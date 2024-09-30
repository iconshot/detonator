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
    
    public static func compareArrays<T: Equatable>(_ a: [T]?, _ b: [T]?) -> Bool {
        if a == nil {
            return b == nil
        }
        
        guard let a = a else {
            return false
        }
        
        guard let b = b else {
            return false
        }
        
        if a.count != b.count {
            return false
        }
        
        for (i, aValue) in a.enumerated() {
            let bValue = b[i]
            
            if aValue != bValue {
                return false
            }
        }
        
        return true
    }
    
    public static func compareStyleTransforms(_ a: StyleTransform?, _ b: StyleTransform?) -> Bool {
        let aTranslateX = a != nil ? a!.translateX : nil;
        let aTranslateY = a != nil ? a!.translateY : nil;
        let aScale = a != nil ? a!.scale : nil;
        let aScaleX = a != nil ? a!.scaleX : nil;
        let aScaleY = a != nil ? a!.scaleY : nil;

        let bTranslateX = b != nil ? b!.translateX : nil;
        let bTranslateY = b != nil ? b!.translateY : nil;
        let bScale = b != nil ? b!.scale : nil;
        let bScaleX = b != nil ? b!.scaleX : nil;
        let bScaleY = b != nil ? b!.scaleY : nil;
        
        return (
            CompareHelper.compareStyleSizes(aTranslateX, bTranslateX) &&
            CompareHelper.compareStyleSizes(aTranslateY, bTranslateY) &&
            CompareHelper.compareStyleSizes(aScale, bScale) &&
            CompareHelper.compareStyleSizes(aScaleX, bScaleX) &&
            CompareHelper.compareStyleSizes(aScaleY, bScaleY)
        );
    }
}
