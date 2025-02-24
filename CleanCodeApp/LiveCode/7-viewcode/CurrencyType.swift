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
    
    func currencyHistory() -> String {
        switch self {
        case .brl:
            return "O Real (BRL) foi introduzido em 1994 como parte do Plano Real para estabilizar a economia brasileira."
        case .usd:
            return "O Dólar Americano (USD) foi criado em 1792 e é a moeda de reserva mais usada no mundo."
        case .eur:
            return "O Euro (EUR) foi introduzido em 1999 e é a moeda oficial da Zona do Euro, utilizada por vários países da União Europeia."
        }
    }
}
