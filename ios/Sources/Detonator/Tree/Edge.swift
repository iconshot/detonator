import UIKit

public class Edge: Decodable {
    var id: Int
    var parent: Int?
    var contentType: String?
    var attributes: String?
    var children: [Edge]
    var text: String?
    var skipped: Bool
    
    var element: Element?
    
    var targetViewsCount: Int = 0
    
    init(id: Int, parent: Int?, contentType: String?, attributes: String?, children: [Edge], text: String?, skipped: Bool, element: Element?, targetViewsCount: Int) {
        self.id = id
        self.parent = parent
        self.contentType = contentType
        self.attributes = attributes
        self.children = children
        self.text = text
        self.skipped = skipped
        self.element = element
        self.targetViewsCount = targetViewsCount
    }
    
    public func clone() -> Edge {
        return Edge(
            id: id,
            parent: parent,
            contentType: contentType,
            attributes: attributes,
            children: children,
            text: text,
            skipped: skipped,
            element: element,
            targetViewsCount: targetViewsCount
        )
    }
    
    public func copyFrom(edge: Edge) {
        id = edge.id
        parent = edge.parent
        contentType = edge.contentType
        attributes = edge.attributes
        children = edge.children
        text = edge.text
        skipped = edge.skipped
        element = edge.element
        targetViewsCount = edge.targetViewsCount
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case parent
        case contentType
        case attributes
        case children
        case text
        case skipped
    }
}
