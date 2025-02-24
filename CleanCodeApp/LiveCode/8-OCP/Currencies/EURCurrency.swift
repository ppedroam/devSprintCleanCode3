//
//  EURCurrency.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import Foundation

struct EURCurrency: CurrencyTypeProtocol {
    var identifier: String {
        "EUR"
    }
    
    var title: String {
        "Euro"
    }
    
    var titlePlural: String {
        "Euros"
    }
    
    func currencyHistory() -> String {
        return "O Euro (EUR) foi introduzido em 1999 e é a moeda oficial da Zona do Euro, utilizada por vários países da União Europeia."
    }
}
