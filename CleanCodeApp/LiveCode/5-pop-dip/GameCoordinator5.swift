//
//  GameCoordinator5.swift
//  CleanCode
//
//  Created by Pedro Menezes on 11/02/25.
//

import UIKit

protocol GameCoordinatorProtocol {
    var viewController: UIViewController? { get set }
    func openFaqScreen()
    func openLastLaunchingScreen()
}

struct GameCoordinator5: GameCoordinatorProtocol {
    weak var viewController: UIViewController?
    
    func openFaqScreen() {
        let faqViewController = FAQViewController(type: .lastUpdates)
        viewController?.navigationController?.pushViewController(faqViewController, animated: true)
    }
    
    func openLastLaunchingScreen() {
        let lastLaunchingsViewController = LastLaunchingsFactory.make()
        viewController?.navigationController?.pushViewController(lastLaunchingsViewController, animated: true)
    }
}
