//
//  RumContactUsAPIService .swift
//  CleanCode
//
//  Created by Rayana Prata Neves on 11/02/25.
//

import Foundation

final class RumContactUsAPIService {
    func fetchContactUsData() async -> Result<ContactUsModel, Error> {
        let url = Endpoints.contactUs
        return await withCheckedContinuation { continuation in
            AF.shared.request(url, method: .get, parameters: nil, headers: nil) { [weak self] response in
                guard let self = self else { return }
                switch response {
                case .success(let data):
                    continuation.resume(returning: self.decodeContactUsData(data))
                case .failure(let error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
    
    private func decodeContactUsData(_ data: Data) -> Result<ContactUsModel, Error> {
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(ContactUsModel.self, from: data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }
    
    func sendMessage(parameters: [String: String]) async -> Result<Void, Error> {
        let url = Endpoints.sendMessage
        return await withCheckedContinuation { continuation in
            AF.shared.request(url, method: .post, parameters: parameters, headers: nil) { response in
                switch response {
                case .success:
                    continuation.resume(returning: .success(()))
                case .failure(let error):
                    continuation.resume(returning: .failure(error))
                }
            }
        }
    }
}
