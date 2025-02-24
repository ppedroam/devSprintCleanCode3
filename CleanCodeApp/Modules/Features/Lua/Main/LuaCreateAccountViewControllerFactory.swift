//
//  LuaCreateAccountViewControllerFabric.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

import UIKit

public struct LuaCreateAccountViewControllerFactory {
    static func makeLuaCreateAccountViewController() -> UIViewController {
        let networkManager = LuaNetworkManager()
        let user = User.init()
        let viewModel = LuaCreateAccountViewModel(user: user, networkManager: networkManager)
        let luaCreateAccountViewController = LuaCreateAccountViewController()
        luaCreateAccountViewController.viewModel = viewModel
        luaCreateAccountViewController.storyboard?.instantiateViewController(withIdentifier: "LuaCreateAccountViewController")
        luaCreateAccountViewController.modalPresentationStyle = .fullScreen
        return luaCreateAccountViewController
    }
}
