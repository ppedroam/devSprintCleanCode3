enum LuzLoginEmailValidatorError: Error {
    case invalidEmail
    case emptyEmail
}

enum LuzLoginEmailValidator {
    static func validate(_ email: String?) throws {
        guard let email, !email.isEmpty else {
            throw LuzLoginEmailValidatorError.emptyEmail
        }

        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        guard email.range(of: emailRegex, options: .regularExpression) != nil else {
            throw LuzLoginEmailValidatorError.invalidEmail
        }
    }
}
