//
//  ViewController.swift
//  ContentFeed
//
//  Created by Geor Kasapidi on 06.03.2021.
//

import UIKit

let demoXML = """
<Root backgroundColor="#fff" alignItems="center" flexDirection="row">
    <Image bundleImageName="1.png" contentMode="scaleAspectFill" positionType="absolute" top="0" left="0" right="0" bottom="0" />
    <Text content="Cool text 1" fontSize="40" italic="true" textBackgroundColor="#FF0000" textColor="#FFFFFF" marginLeft="20" flex="1" appearanceDelay="1" />
    <Text content="Cool text 2" fontSize="40" textBackgroundColor="#00FF00" textColor="#FFFFFF" flex="1" positionType="absolute" top="100" right="100" appearanceDelay="2" />
    <Text content="Cool text 3" fontSize="40" textBackgroundColor="#0000FF" textColor="#FFFFFF" flex="1" positionType="absolute" bottom="100" right="100" appearanceDelay="3" />
</Root>
"""

class ViewController: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        XML.parse(text: demoXML).flatMap {
            XMLayout.makeLayoutNode($0)
        }.flatMap {
            let vc = LayoutViewController(rootNode: $0)

            self.present(vc, animated: true, completion: nil)
        }
    }
}

