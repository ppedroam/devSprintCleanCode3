//
//  String+extensions.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 13/02/25.
//

extension String {
    func isEmailValid() -> Bool {
        let email = self
        let minimunCharactersQuantityForEmail = 5

        let emailHasValue = !email.isEmpty
        let emailContainsDot = email.contains(".")
        let emailContainsAtSymbol = email.contains("@")
        let emailHaveMinimunLength = email.count > minimunCharactersQuantityForEmail

        let isEmailValid = emailHasValue && emailContainsDot && emailContainsAtSymbol && emailHaveMinimunLength

        return isEmailValid
    }
}
