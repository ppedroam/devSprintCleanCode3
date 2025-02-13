//
//  LuaResetPasswordViewModelFabric.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

public struct LuaResetPasswordViewModelFactory {
    static func makeLuaResetPasswordViewModel() -> LuaResetPasswordViewModelProtocol {
        let alertErrorHandler = LuaAlertErrorHandlerFactory.makeAlertErrorHandle()
        let coordinator = LuaBasicCoordinatorFactory.makeBasicCoordinator()
        return LuaResetPasswordViewModel(alertHandler: alertErrorHandler, luaBasicCoordinator: coordinator)
    }
}
