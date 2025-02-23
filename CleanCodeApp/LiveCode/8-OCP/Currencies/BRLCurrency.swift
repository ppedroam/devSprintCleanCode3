//
//  BRLCurrency.swift
//  CleanCode
//
//  Created by Pedro Menezes on 19/02/25.
//

import Foundation

struct BrlCurrency: CurrencyTypeProtocol {
    var identifier: String {
        "BRL"
    }
    
    var title: String {
        "Real"
    }
    
    var titlePlural: String {
        "Reais"
    }
    
    func currencyHistory() -> String {
        return "O Real (BRL) foi introduzido em 1994 como parte do Plano Real para estabilizar a economia brasileira."
    }
}
