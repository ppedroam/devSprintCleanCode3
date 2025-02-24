import UIKit

enum LuzHomeFactory {
    static func make() -> UINavigationController {
        UINavigationController(rootViewController: LuzHomeViewController())
    }
}
