//
//  ResetPasswordViewModelProtocol.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//


protocol FozResetPasswordManaging: AnyObject {
    var onPasswordResetSuccess: ((String) -> Void)? { get set }
    var onPasswordResetFailure: ((String) -> Void)? { get set }
    func performPasswordReset(withEmail email: String?)
    func isEmailValid(_ email: String?) -> Bool
}
