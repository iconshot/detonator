class ImageGetSizeRequest: Request {
    override public func run() {
        let urlString: String = decode()!
        
        ImageHelper.getImageSize(urlString: urlString) { size, error in
            if let error = error {
                self.error(error: error)
            } else {
                let imageSize = ImageSize(width: Int(size!.width), height: Int(size!.height))
                
                self.end(data: imageSize)
            }
        }
    }
    
    struct ImageSize: Encodable {
        let width: Int
        let height: Int
    }
}
