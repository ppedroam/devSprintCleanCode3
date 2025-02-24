//
//  MelContactUsService.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 15/02/25.
//

import Foundation

protocol MelContactUsServiceProtocol: AnyObject {
    func fetchContactData() async throws -> ContactUsModel
    func sendContactUsMessage(_ parameters: [String: String]) async throws -> Data
}

final class MelContactUsService: MelContactUsServiceProtocol {
    private let networking: MelNetworking
    
    init(networking: MelNetworking) {
        self.networking = networking
    }
    
    public func fetchContactData() async throws -> ContactUsModel {
        let url = Endpoints.contactUs
        let data = try await networking.request(url, method: .get, parameters: nil, headers: nil)
        let contactData = try decodeContactData(data)
        return contactData
    }
    
    private func decodeContactData(_ data: Data) throws -> ContactUsModel {
        let decoder = JSONDecoder()
        return try decoder.decode(ContactUsModel.self, from: data)
    }
    
    public func sendContactUsMessage(_ parameters: [String : String]) async throws -> Data {
        let url = Endpoints.sendMessage
        let data = try await networking.request(url, method: .post, parameters: parameters, headers: nil)
        return data
    }
}
