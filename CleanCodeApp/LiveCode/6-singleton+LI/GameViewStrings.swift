//
//  GameViewStrings.swift
//  CleanCode
//
//  Created by Pedro Menezes on 17/02/25.
//

import UIKit

enum GameViewStrings {
    static let launchingsButtonTitle = "Ver lançamentos"
    static let errorTitle = "Tente novamente mais tarde"
    static let errorDescription = "Ooops..."
}

extension UIButton {
    static func applyStyle(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
//        launchButton.addTarget(self, action: #selector(openLastLaunchingsScreen), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.blue.cgColor
        button.layer.borderWidth = 1
        return button
    }
    
    func applyStyle(title: String) {
        
        self.setTitle(title, for: .normal)
//        launchButton.addTarget(self, action: #selector(openLastLaunchingsScreen), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 1
    }
}
