//
//  ResetPasswordViewModelProtocol.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//


protocol FozResetPasswordManaging: AnyObject {
    func performPasswordReset(withEmail email: String?) async throws -> String
    func isEmailValid(_ email: String?) -> Bool
}
