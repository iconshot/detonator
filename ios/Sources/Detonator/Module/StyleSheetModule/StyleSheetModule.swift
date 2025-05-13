class StyleSheetModule: Module {
    public override func register() -> Void {
        detonator.addMessageHandler(key: "com.iconshot.detonator.stylesheet/create") { dataString in
            let idStyleEntries: [IdStyleEntry] = self.detonator.decode(dataString)!
            
            for idStyleEntry in idStyleEntries {
                StyleSheetModule.styleEntries[idStyleEntry.id] = idStyleEntry.styleEntry
            }
        }
        
        detonator.addMessageHandler(key: "com.iconshot.detonator.stylesheet/applyStyle") { dataString in
            let elementStyleEntries: [ElementStyleEntry] = self.detonator.decode(dataString)!
            
            for elementStyleEntry in elementStyleEntries {
                let edge = self.detonator.getEdge(edgeId: elementStyleEntry.elementId)
                
                edge!.element!.applyStyle(styleEntries: elementStyleEntry.styleEntries)
            }
            
            self.detonator.performLayout()
        }
        
        detonator.addMessageHandler(key: "com.iconshot.detonator.stylesheet/removeStyle") { dataString in
            let elementRemoveStyleEntries: [ElementRemoveStyleEntry] = self.detonator.decode(dataString)!
            
            for elementRemoveStyleEntry in elementRemoveStyleEntries {
                let edge = self.detonator.getEdge(edgeId: elementRemoveStyleEntry.elementId)
                
                edge!.element!.removeStyle(toRemoveKeys: elementRemoveStyleEntry.toRemoveKeys)
            }
            
            self.detonator.performLayout()
        }
    }
    
    public static var styleEntries: [Int: StyleEntry] = [:]
    
    struct IdStyleEntry: Decodable {
        let id: Int
        let styleEntry: StyleEntry
    }
    
    struct ElementStyleEntry: Decodable {
        let elementId: Int
        let styleEntries: [StyleEntry]
    }
    
    struct ElementRemoveStyleEntry: Decodable {
        let elementId: Int
        let toRemoveKeys: [[String]?]
    }
}

