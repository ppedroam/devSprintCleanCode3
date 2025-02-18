//
//  RumContactUsAPIService .swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 11/02/25.
//

import Foundation

final class RumContactUsAPIService {
    func fetchContactUsData() async -> Result<ContactUsModel, RumContactUsError> {
        let url = Endpoints.contactUs
        return await withCheckedContinuation { continuation in
            AF.shared.request(url, method: .get, parameters: nil, headers: nil) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let data):
                    continuation.resume(returning: self.decodeContactUsData(data))
                case .failure(_):
                    continuation.resume(returning: .failure(.networkError))
                }
            }
        }
    }
    
    private func decodeContactUsData(_ data: Data) -> Result<ContactUsModel, RumContactUsError> {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(ContactUsModel.self, from: data)
            return .success(model)
        } catch {
            return .failure(.decodingError)
        }
    }
    
    func sendMessage(parameters: [String: String]) async -> Result<Void, RumContactUsError> {
        let url = Endpoints.sendMessage
        return await withCheckedContinuation { continuation in
            AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { response in
                switch response {
                case .success:
                    continuation.resume(returning: .success(()))
                case .failure(_):
                    continuation.resume(returning: .failure(.networkError))
                }
            }
        }
    }
}
