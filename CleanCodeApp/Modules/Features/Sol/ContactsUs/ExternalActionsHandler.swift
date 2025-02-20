//
//  UrlLinks.swift
//  CleanCode
//
//  Created by Ely Assumpcao Ndiaye on 08/02/25.
//

import Foundation


enum ExternalActionsHandler {
    case phone(String)
    case email(String)
    case whatsapp(String)

    var url: URL? {
        switch self {
        case .phone(let number):
            return URL(string: "tel://\(number)")
        case .email(let email):
            return URL(string: "mailto://\(email)")
        case .whatsapp(let phoneNumber):
            return URL(string: "whatsapp://send?phone=\(phoneNumber)&text=Oi")
        }
    }

    var fallbackURL: URL? {
        switch self {
        case .whatsapp:
            return URL(string: "https://apps.apple.com/app/whatsapp-messenger/id310633997")
        default:
            return nil
        }
    }
}

