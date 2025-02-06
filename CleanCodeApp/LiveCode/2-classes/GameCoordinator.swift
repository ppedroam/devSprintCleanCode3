//
//  GameCoordinator.swift
//  CleanCode
//
//  Created by Pedro Menezes on 05/02/25.
//

import UIKit

struct GameCoordinator {
    
    weak var viewController: UIViewController?
    
    func openFaq() {
        let faqVC = FAQViewController(type: .lastUpdates)
        viewController?.navigationController?.pushViewController(faqVC, animated: true)
    }
    
    func openNextScreen() {
        let lastLaunchingsVC = LastLaunchingsFactory.make()
        viewController?.navigationController?.pushViewController(lastLaunchingsVC, animated: true)
    }
}
