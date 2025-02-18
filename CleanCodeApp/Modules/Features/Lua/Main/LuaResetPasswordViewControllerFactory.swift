//
//  LuaResetPasswordViewControllerFactory.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 13/02/25.
//

import UIKit

struct LuaResetPasswordViewControllerFactory {
    static func makeLuaResetPasswordViewController() -> UIViewController {
        let viewModel = LuaResetPasswordViewModelFactory.makeLuaResetPasswordViewModel()
        let coordinator = LuaBasicCoordinator()
        let viewController = LuaResetPasswordViewController(viewModel: viewModel, coordinator: coordinator)
        viewController.modalPresentationStyle = .fullScreen
        coordinator.viewController = viewController
        return viewController
    }
}
