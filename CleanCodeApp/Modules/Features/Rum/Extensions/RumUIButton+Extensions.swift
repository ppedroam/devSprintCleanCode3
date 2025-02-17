//
//  RumUIButton+Extensions.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 05/02/25.
//

import UIKit

extension UIButton {
    func setSymbolImage(systemName: String, pointSize: CGFloat, for state: UIControl.State = .normal) {
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: pointSize)
        let image = UIImage(systemName: systemName)?.withConfiguration(symbolConfiguration)
        setImage(image, for: state)
    }
}
