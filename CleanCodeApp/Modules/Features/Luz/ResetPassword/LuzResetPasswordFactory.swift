import UIKit

enum LuzResetPasswordFactory {
    static func make() -> UIViewController {
        let storyboard = UIStoryboard(name: "LuzUser", bundle: nil)
        let viewController = storyboard.instantiateViewController(
            withIdentifier: "LuzResetPasswordViewController"
        ) as! LuzResetPasswordViewController
        return viewController
    }
}
