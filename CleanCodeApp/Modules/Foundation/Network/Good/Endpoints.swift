enum Endpoints {
    enum Auth {
        static let createUser = "www.aplicandoCleanCode.muito.foda/create"
        static let login = "www.aplicandoCleanCode.muito.foda/login"
        static let resetPassword = "www.aplicandocleancodedemaneirafodastico.com/resetPassword"
    }
    static let contactUs = "www.apiQualquer.com/contactUs"
    static let sendMessage = "www.apiQualquer.com/sendMessage"
}

extension Endpoints {
    static func createUrl(baseUrl: String, endpointPath: String) -> String {
        return "\(baseUrl)\(endpointPath)"
    }
}
