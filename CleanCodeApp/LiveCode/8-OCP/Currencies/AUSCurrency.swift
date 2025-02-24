//
//  AusCurrency.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import Foundation

struct AUSCurrency: CurrencyTypeProtocol {
    var identifier: String {
        "AUS"
    }
    
    var title: String {
        "Peso Argentino"
    }
    
    var titlePlural: String {
        "Pesos Argentinos"
    }
    
    func currencyHistory() -> String {
        return ""
    }
}
