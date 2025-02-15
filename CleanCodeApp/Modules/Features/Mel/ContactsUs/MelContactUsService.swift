//
//  MelContactUsService.swift
//  CleanCodeApp
//
//  Created by Bruno Moura on 15/02/25.
//

import Foundation

final class MelContactUsService {
    public func fetchContactData(completion: @escaping (Result<ContactUsModel, Error>) -> Void) {
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { result in
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
    
    public func sendRequest(_ parameters: [String : String], completion: @escaping (Result<Data, Error>) -> Void) {
        let url = Endpoints.sendMessage
        AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { result in
            completion(result)
        }
    }
}
