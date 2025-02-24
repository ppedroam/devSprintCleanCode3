//
//  BasicCoodinator.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

import UIKit

public protocol LuaCoordinatorProtocol {
    var viewController: UIViewController? {get set}
    func openLuaContactUsScreen()
    func openLuaCreateAccountScreen()
}

final class LuaBasicCoordinator: LuaCoordinatorProtocol {

    weak var viewController: UIViewController?
    
    func openLuaContactUsScreen() {
        let luaContactUsViewController = LuaContactUsViewControllerFactory.makeLuaContactUsViewController()
        viewController?.present(luaContactUsViewController, animated: true, completion: nil)
    }
    
    func openLuaCreateAccountScreen() {
        let luaCreateAccountViewController = LuaCreateAccountViewControllerFactory.makeLuaCreateAccountViewController()
        viewController?.present(luaCreateAccountViewController, animated: true)
    }
}

