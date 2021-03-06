import Foundation

enum XML {
    final class Node {
        fileprivate(set) var name: String = ""
        fileprivate(set) var attributes: [String: String] = [:]
        fileprivate(set) var children: [Node] = []

        fileprivate init() {}
    }

    static func parse(text: String) -> Node? {
        text.data(using: .utf8).flatMap {
            let parser = Parser(data: $0)

            return parser.parse()
        }
    }

    private final class Parser: NSObject, XMLParserDelegate {
        private var rootNode: Node?

        private var nodeStack: [Node] = []

        private let parser: XMLParser

        init(data: Data) {
            self.parser = .init(data: data)

            super.init()

            self.parser.delegate = self
        }

        func parse() -> Node? {
            self.parser.parse()

            return self.rootNode
        }

        func parser(
            _ parser: XMLParser,
            didStartElement elementName: String,
            namespaceURI: String?,
            qualifiedName qName: String?,
            attributes attributeDict: [String : String] = [:]
        ) {
            let newNode = Node()
            newNode.name = elementName
            newNode.attributes = attributeDict

            if self.rootNode == nil {
                self.rootNode = newNode
            }

            self.nodeStack.last?.children.append(newNode)

            self.nodeStack.append(newNode)
        }

        func parser(
            _ parser: XMLParser,
            didEndElement elementName: String,
            namespaceURI: String?,
            qualifiedName qName: String?
        ) {
            if !self.nodeStack.isEmpty {
                self.nodeStack.removeLast()
            }
        }
    }
}
