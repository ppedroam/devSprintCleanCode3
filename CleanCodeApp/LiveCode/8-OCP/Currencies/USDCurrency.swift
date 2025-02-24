//
//  USDCurrency.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import Foundation

struct USDCurrency: CurrencyTypeProtocol {
    var identifier: String {
        "USD"
    }
    
    var title: String {
        "Dólar Americano"
    }
    
    var titlePlural: String {
        "Dólares Americanos"
    }
    
    func currencyHistory() -> String {
        return "O Dólar Americano (USD) foi criado em 1792 e é a moeda de reserva mais usada no mundo."
    }
}
