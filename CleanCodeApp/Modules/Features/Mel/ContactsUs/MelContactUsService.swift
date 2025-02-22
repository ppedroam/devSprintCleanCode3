//
//  MelContactUsService.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 15/02/25.
//

import Foundation

protocol MelContactUsServiceProtocol: AnyObject {
    func fetchContactData(completion: @escaping (Result<ContactUsModel, Error>) -> Void)
    func sendContactUsMessage(_ parameters: [String: String], completion: @escaping (Result<Data, Error>) -> Void)
}

final class MelContactUsService: MelContactUsServiceProtocol {
    private let networking: Networking
    
    init(networking: Networking) {
        self.networking = networking
    }
    
    public func fetchContactData(completion: @escaping (Result<ContactUsModel, Error>) -> Void) {
        let url = Endpoints.contactUs
        networking.request(url, method: .get, parameters: nil, headers: nil) { [weak self] result in
            guard let self = self else { return }
            do {
                let data = try result.get()
                let contactModel = try self.decodeContactData(data)
                completion(.success(contactModel))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func decodeContactData(_ data: Data) throws -> ContactUsModel {
        let decoder = JSONDecoder()
        return try decoder.decode(ContactUsModel.self, from: data)
    }
    
    public func sendContactUsMessage(_ parameters: [String : String], completion: @escaping (Result<Data, Error>) -> Void) {
        let url = Endpoints.sendMessage
        networking.request(url, method: .post, parameters: parameters, headers: nil) { result in
            completion(result)
        }
    }
}
