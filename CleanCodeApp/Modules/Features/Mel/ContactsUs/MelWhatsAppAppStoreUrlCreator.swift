//
//  MelWhatsAppAppStoreUrlCreator.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 20/02/25.
//

import Foundation

struct MelWhatsAppAppStoreUrlCreator: ExternalUrlCreator {
    private let urlString = "https://apps.apple.com/app/whatsapp-messenger/id310633997"
    
    func make() throws -> URL {
        guard let url = URL(string: urlString) else {
            throw UrlErros.invalidUrl
        }
        return url
    }
}
