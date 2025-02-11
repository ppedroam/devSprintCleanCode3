//
//  LuaResetPasswordViewModelFabric.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

public struct LuaResetPasswordViewModelFabric {
    static func makeLuaResetPasswordViewModel() -> LuaResetPasswordViewModel {
        let alertErrorHandler = LuaAlertErrorHandlerFabric.makeAlertErrorHandle()
        return LuaResetPasswordViewModel(alertHandler: alertErrorHandler)
    }
}
