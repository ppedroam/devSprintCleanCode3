//
//  Coordinator.swift
//  CleanCodeApp
//
//  Created by Alexandre César Brandão de Andrade on 11/02/25.
//

import Foundation
import UIKit

protocol Coordinating {
    var navigationController: UINavigationController { get set }
    func make()
    func showContactUs()
    func showCreateAccount() 
}
