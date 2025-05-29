class VideoSeekRequest: Request {
    override public func run() {
        let position: Int! = decodeData()
        
        let edge = getComponentEdge()!
        
        let element = edge.children[0].element as! VideoElement
        
        do {
            try element.seek(position: position)
            
            end()
        } catch {
            self.error(error: error)
        }
    }
}
