//
//  ResetPasswordServicing.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//
import Foundation

protocol ResetPasswordServicing {
    func performPasswordReset(with parameters: [String: String], completion: @escaping (Bool) -> Void)
}
