//
//  LuaContactUsViewControllerFactory.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

import UIKit

public struct LuaContactUsViewControllerFactory {
    static func makeLuaContactUsViewController() -> UIViewController {
        let viewModel = LuaContactUsViewModelFactory.makeLuaContactUsViewModel()
        let luaContactUsViewController = LuaContactUsViewController(viewModel: viewModel)
        luaContactUsViewController.modalPresentationStyle = .fullScreen
        luaContactUsViewController.modalTransitionStyle = .coverVertical
        return luaContactUsViewController
    }
}
