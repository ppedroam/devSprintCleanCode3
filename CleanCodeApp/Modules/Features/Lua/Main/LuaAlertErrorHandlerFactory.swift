//
//  LuaAlertErrorHandlerFabric.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

public struct LuaAlertErrorHandlerFactory {
    static func makeAlertErrorHandle() -> LuaAlertErrorHandlerProtocol {
        return LuaAlertErrorHandler()
    }
}
