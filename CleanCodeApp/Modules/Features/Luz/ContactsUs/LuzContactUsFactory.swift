import UIKit

enum LuzContactUsFactory {
    static func make() -> UIViewController {
        var model: ContactUsModel?
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 36)

        return LuzContactUsViewController(
            model: model,
            symbolConfiguration: symbolConfiguration
        )
    }
}
