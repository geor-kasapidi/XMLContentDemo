import Foundation
import UIKit
import Asana
import SwiftYoga
import CYoga

enum XMLayout {
    static func makeLayoutNode(_ xmlNode: XML.Node) -> LayoutNode? {
        switch xmlNode.name {
        case "Image":
            return LayoutNode(children: []) {
                $0.setup(attributes: xmlNode.attributes)
            } view: { (view: UIImageView, isNew) in
                view.clipsToBounds = true

                self.setupCommonViewAttributes(view: view, attributes: xmlNode.attributes, isNew: isNew)

                switch xmlNode.attributes["contentMode"] {
                case "scaleAspectFit":
                    view.contentMode = .scaleAspectFit
                case "scaleAspectFill":
                    view.contentMode = .scaleAspectFill
                case "scaleToFill":
                    view.contentMode = .scaleToFill
                default: break
                }

                view.image = xmlNode.attributes["bundleImageName"].flatMap {
                    UIImage(named: $0)
                }
            }
        case "Text":
            let fontSize = xmlNode.attributes["fontSize"].flatMap {
                Double($0)
            } ?? 17

            var textAttributes: [NSAttributedString.Key: Any] = [:]

            if xmlNode.attributes["italic"] == "true" {
                textAttributes[.font] = UIFont.italicSystemFont(ofSize: CGFloat(fontSize))
            } else {
                textAttributes[.font] = UIFont.systemFont(ofSize: CGFloat(fontSize))
            }

            xmlNode.attributes["textBackgroundColor"].flatMap {
                UIColor(hex: $0)
            }.flatMap {
                textAttributes[.backgroundColor] = $0
            }

            xmlNode.attributes["textColor"].flatMap {
                UIColor(hex: $0)
            }.flatMap {
                textAttributes[.foregroundColor] = $0
            }

            let string = NSAttributedString(
                string: xmlNode.attributes["content"] ?? "",
                attributes: textAttributes
            )

            return LayoutNode(sizeProvider: string) {
                $0.setup(attributes: xmlNode.attributes)
            } view: { (label: UILabel, isNew) in
                self.setupCommonViewAttributes(view: label, attributes: xmlNode.attributes, isNew: isNew)

                if isNew {
                    label.numberOfLines = 0
                }
                label.attributedText = string
            }

        default:
            let children = xmlNode.children.map {
                self.makeLayoutNode($0)
            }

            return LayoutNode(children: children) {
                $0.setup(attributes: xmlNode.attributes)
            } view: { (view: UIView, isNew) in
                self.setupCommonViewAttributes(view: view, attributes: xmlNode.attributes, isNew: isNew)
            }
        }
    }

    private static func setupCommonViewAttributes(view: UIView, attributes: [String: String], isNew: Bool) {
        if isNew {
            attributes["appearanceDelay"].flatMap {
                Double($0)
            }.flatMap {
                view.isHidden = true

                DispatchQueue.main.asyncAfter(deadline: .now() + $0) { [weak view] in
                    view?.isHidden = false
                }
            }
        }

        attributes["backgroundColor"].flatMap {
            UIColor(hex: $0)
        }.flatMap {
            view.backgroundColor = $0
        }

        attributes["cornerRadius"].flatMap {
            Double($0)
        }.flatMap {
            view.layer.cornerRadius = CGFloat($0)
        }
    }
}

extension NSAttributedString: SizeProvider {
    public func calculateSize(bounds: CGSize) -> CGSize {
        self.boundingRect(with: bounds, options: .usesLineFragmentOrigin, context: nil).size
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255

                    self.init(red: r, green: g, blue: b, alpha: 1)
                    return
                }
            }
        }

        return nil
    }
}
