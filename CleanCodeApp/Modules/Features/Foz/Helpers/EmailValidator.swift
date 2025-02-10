//
//  EmailValidator.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 08/02/25.
//


struct EmailValidator {
    static func isValid(_ email: String?) -> Bool {
        guard let email = email?.trimmingCharacters(in: .whitespaces), !email.isEmpty else { return false }
        return email.contains("@") && email.contains(".") && email.count > 5
    }
}