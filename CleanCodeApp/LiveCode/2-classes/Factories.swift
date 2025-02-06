//
//  Factories.swift
//  CleanCode
//
//  Created by Pedro Menezes on 05/02/25.
//

import UIKit

enum LastLaunchingsFactory {
    static func make() -> UIViewController {
        let analytics = LastLaunchAnallytics()
        let service = LastLaunchingsService()
        let viewModel = LastLaunchingsViewModel(service: service, analytics: analytics)
        let lastLaunchingsVC = LastLaunchingsViewController(viewModel: viewModel)
        return lastLaunchingsVC
    }
}

enum GameFactory {
    static func make() -> UIViewController {
        let coordinator = GameCoordinator()
        let viewController = GameViewController()
        coordinator.viewController = viewController
        return viewController
    }
}
