//
//  LuaCreateAccountViewControllerFabric.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

import UIKit

public struct LuaCreateAccountViewControllerFactory {
    static func makeLuaCreateAccountViewController() -> UIViewController {
        let luaCreateAccountViewController = LuaCreateAccountViewController()
        luaCreateAccountViewController.modalPresentationStyle = .fullScreen
        return luaCreateAccountViewController
    }
}
