//
//  LuaAppURLTarget.swift
//  CleanCodeApp
//
//  Created by Gabriel Amaral on 15/02/25.
//

import Foundation

protocol LuaUrlTargetsProtocol {
    var url: URL? { get }
    var fallBackURL: URL? { get }
}

public struct PhoneTarget: LuaUrlTargetsProtocol {
 
    var phoneNumer: String

    var url: URL? {
        return URL(string: "tel://\(phoneNumer)")
    }
    
    var fallBackURL: URL? {
        return nil
    }
}


public struct MailTarget: LuaUrlTargetsProtocol {
 
    var mail: String

    var url: URL? {
        return URL(string: "mailto:\(mail)")
    }
    
    var fallBackURL: URL? {
        return nil
    }
}


public struct WhatsappTarget: LuaUrlTargetsProtocol {
 
    var whatsappNumber: String

    var url: URL? {
        return URL(string: "whatsapp://send?phone=\(whatsappNumber)&text=Oi)")
    }
    
    var fallBackURL: URL? {
        return URL(string:"https://apps.apple.com/app/whatsapp-messenger/id310633997")
    }
}
