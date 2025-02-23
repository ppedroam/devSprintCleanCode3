//
//  RumContactUsFactory.swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 22/02/25.
//

import UIKit

enum RumContactUsFactory {
    static func make() -> UIViewController {
        let service = RumContactUsAPIService()
        let viewController = RumContactUsViewController(service: service)
        service.delegate = viewController
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        return viewController
    }
}
