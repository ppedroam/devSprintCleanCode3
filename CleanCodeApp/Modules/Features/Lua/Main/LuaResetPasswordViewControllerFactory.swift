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
        let storyboard = UIStoryboard(name: "LuaUser", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "LuaResetPasswordViewController") as? LuaResetPasswordViewController else {
            fatalError("Could not instantiate LuaResetPasswordViewController from LuaUser storyboard")
        }
        viewController.configure(viewModel: viewModel, coordinator: coordinator)
        viewController.modalPresentationStyle = .fullScreen
        
        coordinator.viewController = viewController
        return viewController
    }
    
}
