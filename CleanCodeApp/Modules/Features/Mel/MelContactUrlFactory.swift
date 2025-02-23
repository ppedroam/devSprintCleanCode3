//
//  MelContactUrlFactory.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 22/02/25.
//


struct MelContactUrlFactory {
    static func makeWhatsAppUrl(for phoneNumber: String) -> ExternalUrlCreator {
        return WhatsppUrlCreator(phoneNumber: phoneNumber)
    }

    static func makeAppStoreUrl() -> ExternalUrlCreator {
        return MelWhatsAppAppStoreUrlCreator()
    }

    static func makePhoneCallUrl(for phoneNumber: String) -> ExternalUrlCreator {
        return TelephoneUrlCreator(number: phoneNumber)
    }

    static func makeEmailUrl(for email: String) -> ExternalUrlCreator {
        return EmailUrlCreator(email: email)
    }
}
