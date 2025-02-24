//
//  LoadingController.swift
//  DeliveryAppChallenge
//
//  Created by Pedro Menezes on 03/11/23.
//

import Foundation
import UIKit

class LoadingInheritageController: UIViewController {
    var loadingView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoadingView() {
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
    
    func removeLoadingView() {
        UIView.animate(withDuration: 0.6, animations: {
            self.loadingView.alpha = 0.0
        }) { _ in
            self.loadingView.removeFromSuperview()
        }
    }
}



