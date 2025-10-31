class StyleSheetModule: Module {
    public static var styleEntries: [Int: StyleEntry] = [:]
    
    public override func setUp() -> Void {
        detonator.setEventListener("com.iconshot.detonator.stylesheet::create") { value in
            let idStyleEntries: [IdStyleEntry] = self.detonator.decode(value)!
            
            for idStyleEntry in idStyleEntries {
                StyleSheetModule.styleEntries[idStyleEntry.id] = idStyleEntry.styleEntry
            }
        }
        
        detonator.setEventListener("com.iconshot.detonator.stylesheet::applyStyle") { value in
            let elementStyleEntries: [ElementStyleEntry] = self.detonator.decode(value)!
            
            for elementStyleEntry in elementStyleEntries {
                let edge = self.detonator.getEdge(elementStyleEntry.elementId)
                
                edge!.element!.applyStyle(styleEntries: elementStyleEntry.styleEntries)
            }
            
            self.detonator.performLayout()
        }
        
        detonator.setEventListener("com.iconshot.detonator.stylesheet::removeStyle") { value in
            let elementRemoveStyleEntries: [ElementRemoveStyleEntry] = self.detonator.decode(value)!
            
            for elementRemoveStyleEntry in elementRemoveStyleEntries {
                let edge = self.detonator.getEdge(elementRemoveStyleEntry.elementId)
                
                edge!.element!.removeStyle(toRemoveKeys: elementRemoveStyleEntry.toRemoveKeys)
            }
            
            self.detonator.performLayout()
        }
    }
    
    private struct IdStyleEntry: Decodable {
        let id: Int
        let styleEntry: StyleEntry
    }
    
    private struct ElementStyleEntry: Decodable {
        let elementId: Int
        let styleEntries: [StyleEntry]
    }
    
    private struct ElementRemoveStyleEntry: Decodable {
        let elementId: Int
        let toRemoveKeys: [[String]?]
    }
}

