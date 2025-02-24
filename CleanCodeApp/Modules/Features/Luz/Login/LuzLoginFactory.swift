import UIKit

enum LuzLoginFactory {
    static func make() -> UIViewController {
        let viewModel = LuzLoginViewModel()
        return LuzLoginViewController(viewModel: viewModel)
    }
}
