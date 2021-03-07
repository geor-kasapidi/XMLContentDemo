import UIKit

let demoXML = """
<Root backgroundColor="#FFFFFF" alignItems="center" flexDirection="row">
    <Image bundleImageName="1.jpg" contentMode="scaleAspectFill" positionType="absolute" top="0" left="0" right="0" bottom="40%" />
    <Text content="Cool text 1" fontSize="40" italic="true" textBackgroundColor="#FF0000" textColor="#FFFFFF" marginLeft="20" flex="1" appearanceDelay="1" />
    <Text content="Эмоциональные портреты
всегда получают хороший отклик,
но, зачастую,
этого недостаточно.
Усильте
эмоции
с помощью
композиции
и правильного ракурса" fontSize="24" italic="true" textBackgroundColor="#00FF00" textColor="#000000" positionType="absolute" top="100" right="100" appearanceDelay="2" width="300" />
    <Text content="Cool text 3" fontSize="40" textBackgroundColor="#0000FF" textColor="#FFFFFF" flex="1" positionType="absolute" bottom="100" right="100" appearanceDelay="3" />
    <Button positionType="absolute" bottom="20" left="20" right="20" height="50" cornerRadius="12" backgroundColor="#FFFF00" alignItems="center" justifyContent="center">
        <Lottie animationBundleName="TwitterHeart" width="100" height="100" />
    </Button>
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
