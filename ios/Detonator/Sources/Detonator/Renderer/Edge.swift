import UIKit

public class Edge: Decodable {
    public var id: Int
    public var parent: Int?
    public var contentType: String?
    public var attributes: String?
    public var children: [Edge]
    public var text: String?
    public var skipped: Bool
    public var moved: Bool
    
    public var element: Element?
    
    public var targetViewsCount: Int = 0
    
    init(
        id: Int,
        parent: Int?,
        contentType: String?,
        attributes: String?,
        children: [Edge],
        text: String?,
        skipped: Bool,
        moved: Bool,
        element: Element?,
        targetViewsCount: Int
    ) {
        self.id = id
        self.parent = parent
        self.contentType = contentType
        self.attributes = attributes
        self.children = children
        self.text = text
        self.skipped = skipped
        self.moved = moved
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
            moved: moved,
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
        moved = edge.moved
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
        case moved
    }
}
