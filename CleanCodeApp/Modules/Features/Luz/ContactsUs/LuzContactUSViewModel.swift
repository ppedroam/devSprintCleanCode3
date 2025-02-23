import Foundation

final class LuzContactUSViewModel {
    var model: ContactUsModel?
    private let serivce: ContactUSServiceProtocol

    init(serivce: ContactUSServiceProtocol) {
        self.serivce = serivce
    }

    func fetch() async throws {
        guard let data = try? await serivce.fetch() else { return }
        let model = try? JSONDecoder().decode(ContactUsModel.self, from: data)
        self.model = model
    }

    func send(parameters: [String: String]) async throws {
        try? await serivce.send(with: parameters)
    }
}
