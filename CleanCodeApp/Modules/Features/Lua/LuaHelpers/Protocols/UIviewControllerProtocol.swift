//
//  UIviewControllerProtocol.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

import UIKit

public protocol LuaViewControllerProtocol {
    associatedtype ViewCode: UIView
    var viewCode: ViewCode { get }
    func hideKeyboardWhenTappedAround()
}

