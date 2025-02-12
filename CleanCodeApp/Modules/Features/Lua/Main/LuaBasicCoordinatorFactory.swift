//
//  Untitled.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 11/02/25.
//

import UIKit

public struct LuaBasicCoordinatorFactory {
    static func makeBasicCoordinator() -> LuaCoordinatorProtocol {
        return LuaBasicCoordinator()
    }
}
