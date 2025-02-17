//
//  LuaContactUsViewModelFactory.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 17/02/25.
//

struct LuaContactUsViewModelFactory {
    static func makeLuaContactUsViewModel() -> LuaContactUsViewModel {
        let viewModel = LuaContactUsViewModel(networkManager: LuaNetworkManager())
        return viewModel
    }
}
