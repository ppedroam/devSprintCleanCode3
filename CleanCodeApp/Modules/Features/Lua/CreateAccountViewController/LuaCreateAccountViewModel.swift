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

struct LuaUserInformation {
    var name: String
    var email: String
    var password: String
    var phoneNumber: String
    var document: String
}

protocol LuaSessionUserDefaultsProtocol {
    func saveSession(with session: Session, and user: User) throws
}

extension LuaSessionUserDefaultsProtocol {
    func saveSession(with session: Session, and user: User) throws {
        let encoder = JSONEncoder()
        try UserDefaults.standard.set(encoder.encode(session), forKey: "sessionNewData")
        try UserDefaults.standard.set(encoder.encode(user), forKey: "userNewData")
        UserDefaults.standard.set(session.id, forKey: "userID")
    }
}

protocol LuaCreateAccountViewModelProtocol {
    var user: User? { get set }
    func validateFormAllForms(with input: LuaRegistrationFormInput) throws
    func updateUserInformation(with info: LuaUserInformation)
    func startAccountCreationProcess() throws
}

final class LuaCreateAccountViewModel: LuaCreateAccountViewModelProtocol, LuaSessionUserDefaultsProtocol {
    public var user: User?
    private let networkManager: LuaNetworkManagerProtocol
    
    init(user: User? = nil, networkManager: LuaNetworkManagerProtocol) {
        self.user = user
        self.networkManager = networkManager
    }
    
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
    
    public func updateUserInformation(with info: LuaUserInformation) {
        user?.name = info.name
        user?.phoneNumber = info.phoneNumber
        user?.email =  info.email
        user?.password = info.password
        user?.document = info.document
    }
    
    public func startAccountCreationProcess() throws {
        Task {
            do {
                try validateConnectivity()
                let userParams = createUserParams()
                let session = try await requestUserCreation(userParams)
                try saveSession(with: session, and: user!)
                try await requestLogin(with: session)
            } catch LuaNetworkError.noInternetConnection {
                throw LuaNetworkError.noInternetConnection
            } catch LuaNetworkError.anyUnintendedResponse {
                throw LuaNetworkError.anyUnintendedResponse
            } catch {
                throw error
            }
        }
    }
}
// MARK: - API
private extension LuaCreateAccountViewModel {
    
    func createUserParams() -> [String: String?] {
        let userParams = [
            "name": user?.name,
            "phone_number": user?.phoneNumber,
            "document": user?.document,
            "document_type": user?.documentType,
            "email": user?.email,
            "password": user?.password,
            "token_id_push": UUID.init().uuidString
        ]
        return userParams
    }
    
    func requestLogin(with session: Session) async throws {
        do {
            let userSession: Session = try await networkManager.request(LuaAuthAPITarget.loginWithSession(session))
        } catch {
            throw LuaNetworkError.anyUnintendedResponse
        }
    }
    
    func requestUserCreation(_ userParams: [String:String?]) async throws -> Session {
        do {
            let userSession: Session = try await networkManager.request(LuaAuthAPITarget.createUser(userParams))
            return userSession
        } catch {
            throw LuaNetworkError.anyUnintendedResponse
        }
    }
    
    private func validateConnectivity() throws {
        guard ConnectivityManager.shared.isConnected else {
            throw LuaNetworkError.noInternetConnection
        }
    }
}

// MARK: - Form Validations
private extension LuaCreateAccountViewModel {
    func validateName(_ name: String) throws {
        let fullNameComponents = name.components(separatedBy: " ")
        let isFullName = fullNameComponents.count > 1
        
        if name.isNotEmpty && isFullName {
            return
        }
        throw LuaCreateAccountFormError.invalidName
    }
    
    func validatePhoneNumber(_ phone: String) throws {
        let isNumberFormatValid = phone.count == 11
        if phone.isNotEmpty && isNumberFormatValid {
            return
        }
        throw LuaCreateAccountFormError.invalidPhone
    }
    
    func validateIdentityDocumentInfo(_ documentInfo: String) throws {
        switch documentInfo.count {
        case 11:
            user?.documentType = "CPF"
        case 14:
            user?.documentType = "CNPJ"
        default:
            throw LuaCreateAccountFormError.invalidIdInfo
        }
    }
    // MARK: - Email Validation
    func validateEmail(_ email: String, confirmation emailConfirmation: String) throws {
        try validateEmailFormat(email)
        try compareEmailMatch(email, confirmation: emailConfirmation)
    }
    
    func validateEmailFormat(_ email: String) throws {
        let isEmailFormatValid = email.contains(".") &&
        email.contains("@") &&
        email.count > 5
        
        if isEmailFormatValid {
            return
        }
        throw LuaCreateAccountFormError.invalidEmail
    }
    
    
    func compareEmailMatch(_ email: String, confirmation emailConfirmation: String) throws {
        let isEmailConfirmationIqual = email == emailConfirmation
        if isEmailConfirmationIqual {
            return
        }
        throw LuaCreateAccountFormError.emailMismatch
    }
    
    // MARK: - Password Validation
    func validatePassword(_ password: String, confirmation passwordConfirmation: String) throws {
        try validatePasswordCapitalLetter(password)
        try validatePasswordNumber(password)
        try validatePasswordLength(password)
        try validatePasswordMatch(password, confirmation: passwordConfirmation)
    }
    
    func validatePasswordCapitalLetter(_ password: String) throws {
        let uppercaseLetters = CharacterSet.uppercaseLetters
        let hasUppercase = password.rangeOfCharacter(from: uppercaseLetters) != nil
        if hasUppercase {
            return
        }
        throw LuaCreateAccountFormError.passwordMissingUppercase
    }
    
    func validatePasswordNumber(_ password: String) throws {
        let numbers = CharacterSet.decimalDigits
        let hasNumber = password.rangeOfCharacter(from: numbers) != nil
        if hasNumber {
            return
        }
        throw LuaCreateAccountFormError.passwordMissingNumber
    }
    
    func validatePasswordLength(_ password: String) throws {
        if password.count >= 6 {
            return
        }
        throw LuaCreateAccountFormError.passwordTooShort
    }
    
    func validatePasswordMatch(_ password: String, confirmation passwordConfirmation: String) throws {
        let isPasswordConfirmationIqual = password == passwordConfirmation
        if isPasswordConfirmationIqual {
            return
        }
        throw LuaCreateAccountFormError.passwordMismatch
    }
}
