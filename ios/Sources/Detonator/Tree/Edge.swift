import UIKit

public class Edge: Decodable {
    var id: Int
    var parent: Int?
    var contentType: String?
    var attributes: String?
    var children: [Edge]
    var text: String?
    var element: Element?
    
    init(id: Int, parent: Int?, contentType: String?, attributes: String?, children: [Edge], text: String?, element: Element?) {
        self.id = id
        self.parent = parent
        self.contentType = contentType
        self.attributes = attributes
        self.children = children
        self.text = text
        self.element = element
    }
    
    public func clone() -> Edge {
        return Edge(
            id: id,
            parent: parent,
            contentType: contentType,
            attributes: attributes,
            children: children,
            text: text,
            element: element
        )
    }
    
    public func copyFrom(edge: Edge) {
        id = edge.id
        parent = edge.parent
        contentType = edge.contentType
        attributes = edge.attributes
        children = edge.children
        text = edge.text
        element = edge.element
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case parent
        case contentType
        case attributes
        case children
        case text
    }
}
