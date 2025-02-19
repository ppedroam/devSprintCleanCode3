import Foundation

protocol ContactUSServiceProtocol {
    func fetch() async throws -> Data
    func send(with parameters: [String: String]) async throws
}

final class ContactUSService: ContactUSServiceProtocol {
    func fetch() async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            AF.shared.request(
                Endpoints.contactUs,
                method: .get,
                parameters: nil,
                headers: nil
            ) { result in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func send(with parameters: [String: String]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AF.shared.request(
                Endpoints.sendMessage,
                method: .post,
                parameters: parameters,
                headers: nil
            ) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
