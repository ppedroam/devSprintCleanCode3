//
//  GameCoordinator.swift
//  CleanCode
//
//  Created by Pedro Menezes on 10/02/25.
//

import UIKit

struct GameCoordinator2 {
    
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
