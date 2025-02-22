//
//  MelLoadingView.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 22/02/25.
//


import Foundation
import UIKit

protocol MelLoadingViewProtocol: AnyObject {
    func showLoadingView()
    func hideLoadingView()
}

class MelLoadingView: UIViewController, MelLoadingViewProtocol {
    private var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func showLoadingView() {
        loadingView = UIView(frame: UIScreen.main.bounds)
        loadingView.backgroundColor = .systemGray2
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.center = loadingView.center
        activityIndicator.color = .blue
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)
        loadingView.alpha = 0.0
        UIView.animate(withDuration: 0.6) {
            self.loadingView.alpha = 1.0
        }
    }
    
    public func hideLoadingView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.loadingView.alpha = 0.0
        }) { _ in
            self.loadingView.removeFromSuperview()
        }
    }
}
