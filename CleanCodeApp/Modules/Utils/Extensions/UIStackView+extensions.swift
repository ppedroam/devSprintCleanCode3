//
//  UIStackView+extensions.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 15/02/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            addArrangedSubview(view)
        }
    }
}
