import Foundation
import UIKit
import Asana

final class LayoutViewController: UIViewController {
    private let rootNode: LayoutNode

    private let contentView = UIView()

    init(rootNode: LayoutNode) {
        self.rootNode = rootNode

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(self.contentView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let layout = LayoutCalculator.makeLayout(
            node: self.rootNode,
            bounds: self.view.bounds.size,
            rtl: self.view.effectiveUserInterfaceLayoutDirection == .rightToLeft
        )

        layout.setup(view: self.contentView)
    }
}
