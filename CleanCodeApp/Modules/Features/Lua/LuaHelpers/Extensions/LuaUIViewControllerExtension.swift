//
//  LuaUIViewControllerExtension.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 17/02/25.
//

import UIKit

extension UIViewController {
    
    func luaShowLoading() async {
        let loadingController = LoadingController() // this is too slow, find other solution later
        loadingController.modalPresentationStyle = .fullScreen
        loadingController.modalTransitionStyle = .crossDissolve
        
        await withCheckedContinuation { continuation in
            present(loadingController, animated: true) {
                print("Loading presentation completed")
                continuation.resume()
            }
        }
    }
    
    func luaStopLoading() async {
        guard let presented = presentedViewController as? LoadingController else {
            print("No loading controller presented")
            return
        }
        
        await withCheckedContinuation { continuation in
            presented.dismiss(animated: true) {
                print("Loading dismissal completed")
                continuation.resume()
            }
        }
    }
}
