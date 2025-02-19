import UIKit

enum LuzContactUsFactory {
    static func make() -> UIViewController {
        let service = ContactUSService()
        let viewModel = LuzContactUSViewModel(serivce: service)
        return LuzContactUsViewController(viewModel: viewModel)
    }
}
