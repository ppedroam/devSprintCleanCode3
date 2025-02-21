import Foundation

struct LuaRegistrationFormInput {
    let name: String
    let phone: String
    let identityDocumentInfo: String
    let email: String
    let emailConfirmation: String
    let password: String
    let passwordConfirmation: String
}

protocol LuaCreateAccountViewModelProtocol {
    var user: User? { get set }
    func validateFormAllForms(with input: LuaRegistrationFormInput) throws
}

final class LuaCreateAccountViewModel: LuaCreateAccountViewModelProtocol {
    public var user: User?
    
    public func validateFormAllForms(with input: LuaRegistrationFormInput) throws {
        do {
            try validateName(input.name)
            try validatePhoneNumber(input.phone)
            try validateIdentityDocumentInfo(input.identityDocumentInfo)
            try validateEmail(input.email, confirmation: input.emailConfirmation)
            try validatePassword(input.password, confirmation: input.passwordConfirmation)
        } catch let error as LuaCreateAccountFormError {
            throw error
        }
    }
    
    public func updateUserProperties() {
        user.documentType = documentType
        user.phoneNumber = inputtedPhone
        user.name = self.nameTextField.text!
        user.document = document
    }
    
    private  func validateName(_ name: String) throws {
        let fullNameComponents = name.components(separatedBy: " ")
        let isFullName = fullNameComponents.count > 1
        
        if name.isNotEmpty && isFullName {
            return
        }
        throw LuaCreateAccountFormError.invalidName
    }
    
    private  func validatePhoneNumber(_ phone: String) throws {
        let isNumberFormatValid = phone.count == 11
        if phone.isNotEmpty && isNumberFormatValid {
            return
        }
        throw LuaCreateAccountFormError.invalidPhone
    }
    
    private  func validateIdentityDocumentInfo(_ IdInfo: String) throws { // need to validate if is CPF OR CNPJ
        if IdInfo.isNotEmpty {
            return
        }
        throw LuaCreateAccountFormError.invalidIdInfo
    }
    
    private  func validateEmail(_ email: String, confirmation emailConfirmation: String) throws { // need to create a different error for email dismatch
        let isEmailFormatValid = email.contains(".") &&
                                 email.contains("@") &&
                                 email.count > 5
        let isEmailConfirmationIqual = email == emailConfirmation
        if isEmailFormatValid && isEmailConfirmationIqual {
            return
        }
        throw LuaCreateAccountFormError.invalidEmail
    }
    // MARK: - Password Validation
    private func validatePassword(_ password: String, confirmation passwordConfirmation: String) throws {
        try validatePasswordCapitalLetter(password)
        try validatePasswordNumber(password)
        try validatePasswordLength(password)
        try validatePasswordMatch(password, confirmation: passwordConfirmation)
    }
    
  
    private func validatePasswordCapitalLetter(_ password: String) throws {
        let uppercaseLetters = CharacterSet.uppercaseLetters
        let hasUppercase = password.rangeOfCharacter(from: uppercaseLetters) != nil
        if hasUppercase {
            return
        }
        throw LuaCreateAccountFormError.passwordMissingUppercase
    }
    
    private func validatePasswordNumber(_ password: String) throws {
        let numbers = CharacterSet.decimalDigits
        let hasNumber = password.rangeOfCharacter(from: numbers) != nil
        if hasNumber {
            return
        }
        throw LuaCreateAccountFormError.passwordMissingNumber
    }
    
    private func validatePasswordLength(_ password: String) throws {
        if password.count >= 6 {
            return
        }
        throw LuaCreateAccountFormError.passwordTooShort
    }
    
    private func validatePasswordMatch(_ password: String, confirmation passwordConfirmation: String) throws {
        let isPasswordConfirmationIqual = password == passwordConfirmation
        if isPasswordConfirmationIqual {
            return
        }
        throw LuaCreateAccountFormError.passwordMismatch
    }
}
