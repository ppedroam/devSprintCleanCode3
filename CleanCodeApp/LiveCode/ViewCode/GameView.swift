//
//  GameView.swift
//  CleanCode
//
//  Created by Pedro Menezes on 10/02/25.
//

import UIKit
import WebKit

final class GameView: UIView {
    let webView = WKWebView()
    
    private let goToLaunchingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ver lançamentos", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(webView)
        addSubview(goToLaunchingsButton)
        
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            goToLaunchingsButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            goToLaunchingsButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func configureButton(target: Any, action: Selector) {
        goToLaunchingsButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
