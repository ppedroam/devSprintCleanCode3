import UIKit

enum LuzResetPasswordFactory {
    static func make() -> UIViewController {
        let viewModel = LuzResetPasswordViewModel()
        let viewController = LuzResetPasswordViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        return viewController
    }
}
