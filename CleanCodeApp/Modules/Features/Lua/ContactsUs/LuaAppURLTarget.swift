//
//  LuaAppURLTarget.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

import Foundation

public enum LuaAppURLTarget {
    
    case phone(String)
    case mail(String)
    case whatsapp(String)
    
    var url: URL? {
        switch self {
        case .phone(let phoneNumer):
            return URL(string: "tel://\(phoneNumer)")
            
        case .mail(let mail):
            return URL(string: "mailto:\(mail)")
            
        case .whatsapp(let whatsappNumber):
            return URL(string:"whatsapp://send?phone=\(whatsappNumber)&text=Oi)")
        }
    }
    
    var fallBackURL: URL? {
        switch self {
        case .whatsapp:
            return URL(string:"https://apps.apple.com/app/whatsapp-messenger/id310633997")
        default:
            return nil
        }
    }
}
