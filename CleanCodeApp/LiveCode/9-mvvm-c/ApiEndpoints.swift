//
//  ApiEndpoints.swift
//  CleanCode
//
//  Created by Pedro Menezes on 20/02/25.
//

import Foundation

enum ApiEndpoints {
    static func createFetchConversionRate(from fromCurrency: String, to toCurrency: String) -> String {
        return "https://api.currencyapi.com/v3/latest?apikey=cur_live_JhWFLtfhpMPH6AElpf3PMcZQmg8dI9kHMnWhLLlM&currencies=\(fromCurrency)&base_currency=\(toCurrency)"
    }
}
