//
//  CurrencyType.swift
//  CleanCode
//
//  Created by Pedro Menezes on 17/02/25.
//

import Foundation

enum CurrencyType: CaseIterable {
    case brl, usd, eur
    
    var identifier: String {
        switch self {
        case .brl: return "BRL"
        case .usd: return "USD"
        case .eur: return "EUR"
        }
    }
    
    var title: String {
        switch self {
        case .brl: return "Real"
        case .usd: return "Dólar Americano"
        case .eur: return "Euro"
        }
    }
    
    var titlePlural: String {
        switch self {
        case .brl: return "Reais"
        case .usd: return "Dólares Americanos"
        case .eur: return "Euros"
        }
    }
}
