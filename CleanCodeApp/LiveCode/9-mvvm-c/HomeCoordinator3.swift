//
//  HomeCoordinator3.swift
//  CleanCode
//
//  Created by Pedro Menezes on 20/02/25.
//

import UIKit

protocol HomeCoordinating {
    func logout()
    func showAlert(availableCurrencies: [CurrencyTypeProtocol],
                   title: String,
                   onCurrencySelected: @escaping (CurrencyTypeProtocol)->Void)
}

class HomeCoordinator3: HomeCoordinating {
    weak var controller: UIViewController?
    
    func logout() {
        UserDefaultsManager.UserInfos.shared.delete()
        let storyboard = UIStoryboard(name: "SolUser", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SolLoginViewController") as! SolLoginViewController
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
    
    func showAlert(availableCurrencies: [CurrencyTypeProtocol],
                   title: String,
                   onCurrencySelected: @escaping (CurrencyTypeProtocol)->Void) {
        let alert = UIAlertController(title: title,
                                      message: nil,
                                      preferredStyle: .actionSheet)
        for currency in availableCurrencies {
            alert.addAction(
                UIAlertAction(title: currency.title, style: .default, handler: { _ in
                    onCurrencySelected(currency)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        controller?.present(alert, animated: true, completion: nil)
    }
}
