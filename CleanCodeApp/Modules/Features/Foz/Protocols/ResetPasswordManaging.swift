//
//  ResetPasswordViewModelProtocol.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//


protocol ResetPasswordManaging: AnyObject {
    var onPasswordResetSuccess: ((String) -> Void)? { get set }
    var onPasswordResetFailure: (() -> Void)? { get set }
    func performPasswordReset(withEmail email: String?)
    func validateEmail(_ email: String?) -> Bool
}
