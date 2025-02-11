//
//  SceneDelegate.swift
//  DeliveryAppChallenge
//
//  Created by Rodrigo Borges on 25/10/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
<<<<<<< HEAD
        let rootViewController = getRootViewController(forUser: .elyAssumpcao)
=======
        let rootViewController = getRootViewController(forUser: .thaisaAmanda)
>>>>>>> upstream/main
        self.window?.rootViewController = UINavigationController(rootViewController: rootViewController)
        self.window?.windowScene = windowScene
        self.window?.makeKeyAndVisible()
    }
}

func getRootViewController(forUser user: Users) -> UIViewController {
    var userIdentifier = ""
    switch user {
    case .jorgeRoberto:
        userIdentifier = "Ceu"
    case .alexandreCesar:
        userIdentifier = "Foz"
    case .gabrielEirado:
        userIdentifier = "Lua"
    case .luisOliveira:
        userIdentifier = "Luz"
    case .jeanCarlos:
        userIdentifier = "Mar"
    case .brunoMoura:
        userIdentifier = "Mel"
    case .giuliaKetlin:
        userIdentifier = "Paz"
    case .thaisaAmanda:
        userIdentifier = "Rio"
    case .rayanaPrata:
        userIdentifier = "Rum"
<<<<<<< HEAD
<<<<<<< HEAD
    case .elyAssuncao:
=======
    case .elyAssumpcao:
>>>>>>> 5d781b2 (feat tratar funções)
=======
    case .elyAssumpcao:
>>>>>>> upstream/main
        userIdentifier = "Sol"
    }
    let storyboard = UIStoryboard(name: "\(userIdentifier)User", bundle: nil)
    let vc = storyboard.instantiateViewController(withIdentifier: "\(userIdentifier)LoginViewController")
    return vc
}

enum Users {
    case jorgeRoberto
    case alexandreCesar
    case gabrielEirado
    case luisOliveira
    case jeanCarlos
    case brunoMoura
    case giuliaKetlin
    case thaisaAmanda
    case rayanaPrata
<<<<<<< HEAD
<<<<<<< HEAD
    case elyAssuncao
=======
    case elyAssumpcao
>>>>>>> 5d781b2 (feat tratar funções)
=======
    case elyAssumpcao
>>>>>>> upstream/main
}
