import UIKit

protocol LuzHomeCoordinatorProtocol {
    func start()
}

final class LuzHomeCoordinator: LuzHomeCoordinatorProtocol {
    private var window: UIWindow?

    public init(window: UIWindow?) {
        self.window = window
    }

    func start() {
        let navigationController = LuzHomeFactory.make()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
