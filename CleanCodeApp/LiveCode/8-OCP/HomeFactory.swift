//
//  HomeFactory.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import UIKit

enum HomeFactory {
    static func make() -> UIViewController {
        let availableCurrencies: [CurrencyTypeProtocol] = [
            BrlCurrency(),
            USDCurrency(),
            EURCurrency(),
            AUSCurrency()
        ]
        let viewController = HomeViewController2(
            selectedCurrencyFrom: availableCurrencies[0],
            selectedCurrencyTo: availableCurrencies[1],
            availableCurrencies: availableCurrencies
        )
        return viewController
    }
}
