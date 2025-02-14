//
//  RumContactUsAPIService .swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 11/02/25.
//

import Foundation

final class RumContactUsAPIService {
    func fetchContactUsData(completion: @escaping (Result<ContactUsModel, Error>) -> Void) {
        let url = Endpoints.contactUs
        AF.shared.request(url, method: .get, parameters: nil, headers: nil) { result in
            switch result {
            case .success(let data):
                self.decodeContactUsData(data, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func decodeContactUsData(_ data: Data, completion: @escaping (Result<ContactUsModel, Error>) -> Void) {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(ContactUsModel.self, from: data)
            completion(.success(model))
        } catch {
            completion(.failure(error))
        }
    }
    
    func sendMessage(parameters: [String: String], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = Endpoints.sendMessage
        AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
