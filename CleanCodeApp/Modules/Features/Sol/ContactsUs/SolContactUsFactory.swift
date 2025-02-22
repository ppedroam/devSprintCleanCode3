//
//  SolContactUsFactory.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 16/02/25.
//

import UIKit

enum SolContactUsFactory {
    static func make() -> UIViewController {
        let viewModel = SolContactUsViewModel()
        let view = SolContactUsView()
        let rootViewController = SolContactUsViewController(viewModel: viewModel, contactUsView: view)
        return rootViewController
    }
}

