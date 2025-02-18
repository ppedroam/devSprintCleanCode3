//
//  RioResetPasswordService.swift
//  CleanCode
//
//  Created by thaisa on 17/02/25.
//

import Foundation
import UIKit

class RioResetPasswordService {
    
    func resetPassword(email: String, completion: @escaping (Bool) -> Void) {
        let parameters = ["email": email]
        
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            BadNetworkLayer.shared.resetPassword(topController, parameters: parameters) { success in
                completion(success)
            }
        } else {
            completion(false)
        }
    }
}
