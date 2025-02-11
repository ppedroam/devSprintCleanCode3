enum ConnectivityError: Error {
    case noInternet
}

enum ConnectivityValidator {
    static func checkInternetConnection() throws {
        if !ConnectivityManager.shared.isConnected {
            throw ConnectivityError.noInternet
        }
    }
}
