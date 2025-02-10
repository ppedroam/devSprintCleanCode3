//
//  ButtonStyler.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 08/02/25.
//

import Foundation
import UIKit

struct ButtonStyler {

    static func stylePrimaryButton(_ button: UIButton){
        button.layer.cornerRadius = button.bounds.height / 2
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
    }

    static func styleSecondaryButton(_ button: UIButton){
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.blue.cgColor
        button.backgroundColor = .white
        button.setTitleColor(.blue, for: .normal)
    }

}
