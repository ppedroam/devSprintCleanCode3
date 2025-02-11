enum ValidationError: Error {
    case emptyEmail
    case invalidFormat
}

enum FormValidator {
    static func validateEmail(_ email: String?) throws {
        guard let email, !email.isEmpty else {
            throw ValidationError.emptyEmail
        }

        guard
            email.contains("@"),
            email.contains("."),
            email.count > 5
        else {
            throw ValidationError.invalidFormat
        }
    }
}
