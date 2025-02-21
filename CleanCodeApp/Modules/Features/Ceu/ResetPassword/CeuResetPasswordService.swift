//
//  CeuResetPasswordService.swift
//  CleanCodeApp
//
//  Created by Jorge de Carvalho on 20/02/25.
//

protocol CeuResetPasswordServiceProtocol {
    func resetPassword(email: String?, completion: @escaping (Result<CeuResetPasswordResponse, Error>) -> Void) throws
}

class CeuResetPasswordService: CeuResetPasswordServiceProtocol {
    private let networkManager: NetworkManagerProtocol

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func resetPassword(email: String?, completion: @escaping (Result<CeuResetPasswordResponse, any Error>) -> Void) throws {
        let parameters = try setupResetPasswordRequestParameters(email: email)
        let resetPasswordRequest: NetworkRequest = ResetPasswordRequest()

        networkManager.request(resetPasswordRequest, completion: completion)
    }

    private func setupResetPasswordRequestParameters(email: String?) throws -> [String: String] {
        guard let email = email else { throw CeuCommonsErrors.invalidData }

        let emailUser = email.trimmingCharacters(in: .whitespaces)
        let parameters = [
            "email": emailUser
        ]

        return parameters
    }


}

public struct CeuResetPasswordResponse: Decodable {
    let success: Bool
    let message: String?
}

class ResetPasswordRequest: NetworkRequest {
    var pathURL: String = Endpoints.Auth.resetPassword
    var method: HTTPMethod = .post
}
