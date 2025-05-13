class SafeAreaViewElement: ViewElement {
    override public func decodeAttributes() -> SafeAreaViewAttributes? {
        return super.decodeAttributes()
    }
    
    override public func patchView() {
        super.patchView()
        
        let attributes = attributes as! SafeAreaViewAttributes
        let prevAttributes = prevAttributes as! SafeAreaViewAttributes?
        
        let edges = attributes.edges
        
        let prevEdges = prevAttributes?.edges
        
        let patchEdgesBool = forcePatch || !CompareHelper.compareArrays(edges, prevEdges)
        
        if patchEdgesBool {
            patchEdges(edges: edges)
        }
    }
    
    func patchEdges(edges: [String]) {
        let view = view as! ViewLayout
        
        let layoutParams = view.layoutParams
        
        view.onSafeAreaInsetsChange = {
            var paddingTop: Float = 0
            var paddingLeft: Float = 0
            var paddingBottom: Float = 0
            var paddingRight: Float = 0
            
            if edges.contains("top") {
                paddingTop = Float(view.safeAreaInsets.top)
            }
            
            if edges.contains("left") {
                paddingLeft = Float(view.safeAreaInsets.left)
            }
            
            if edges.contains("bottom") {
                paddingBottom = Float(view.safeAreaInsets.bottom)
            }
            
            if edges.contains("right") {
                paddingRight = Float(view.safeAreaInsets.right)
            }
            
            layoutParams.padding.top = paddingTop
            layoutParams.padding.left = paddingLeft
            layoutParams.padding.bottom = paddingBottom
            layoutParams.padding.right = paddingRight
            
            self.detonator.performLayout()
        }

        view.onSafeAreaInsetsChange?()
    }
    
    override func patchPadding(
        padding: Float?,
        paddingHorizontal: Float?,
        paddingVertical: Float?,
        paddingTop: Float?,
        paddingLeft: Float?,
        paddingBottom: Float?,
        paddingRight: Float?
    ) {
    }
    
    class SafeAreaViewAttributes: ViewAttributes {
        var edges: [String]
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            edges = try container.decode([String].self, forKey: .edges)
            
            try super.init(from: decoder)
        }
        
        private enum CodingKeys: String, CodingKey {
            case edges
        }
    }
}
