//
//  LuaResetPasswordViewModelFabric.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

public struct LuaResetPasswordViewModelFactory {
    static func makeLuaResetPasswordViewModel() -> LuaResetPasswordViewModelProtocol {
        let viewModel = LuaResetPasswordViewModel(networkManager: LuaNetworkManager())
        return viewModel
    }
}
