//
//  CurrencyType2.swift
//  CleanCode
//
//  Created by Pedro Menezes on 18/02/25.
//

import Foundation

protocol CurrencyTypeProtocol {
    var identifier: String { get }
    var title: String { get }
    var titlePlural: String { get }
    func currencyHistory() -> String
}

