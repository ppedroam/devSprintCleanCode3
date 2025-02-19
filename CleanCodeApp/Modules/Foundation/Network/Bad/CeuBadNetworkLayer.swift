import Foundation
import UIKit

protocol CeuBadNetworkLayerProtocol {
    func checkPassword(_ targetVc: UIViewController,
                       parameters: [String : String],
                       completionHandler: @escaping (Bool) -> Void)

    func sendPasswordEmail(_ targetVc: UIViewController,
                           parameters: [String : String],
                           completionHandler: @escaping (Bool) -> Void)

    func createPassword(_ targetVc: UIViewController,
                        parameters: [String : String],
                        completionHandler: @escaping (String?) -> Void)

    func resetPassword(_ targetVc: UIViewController,
                       parameters: [String : String],
                       completionHandler: @escaping (Bool) -> Void)

    func login(_ targetVc: UIViewController,
               parameters: [String : String],
               completionHandler: @escaping (Session?) -> Void) 
}

class CeuBadNetworkLayer: CeuBadNetworkLayerProtocol {
    func checkPassword(_ targetVc: UIViewController,
                       parameters: [String : String],
                       completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            targetVc.stopLoading()
            completionHandler(true)
        }
    }

    func sendPasswordEmail(_ targetVc: UIViewController,
                           parameters: [String : String],
                           completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            targetVc.stopLoading()
            completionHandler(true)
        }
    }

    func createPassword(_ targetVc: UIViewController,
                        parameters: [String : String],
                        completionHandler: @escaping (String?) -> Void) {
        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            targetVc.stopLoading()
            let uuid = UUID.init().uuidString
            completionHandler(uuid)
        }
    }



    func resetPassword(_ targetVc: UIViewController,
                       parameters: [String : String],
                       completionHandler: @escaping (Bool) -> Void) {

        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            targetVc.stopLoading()
            completionHandler(true)
        }
    }

    func login(_ targetVc: UIViewController,
               parameters: [String : String],
               completionHandler: @escaping (Session?) -> Void) {

        DispatchQueue.main.async {
            targetVc.showLoading()
        }

        let endpoint = Endpoints.Auth.login
        AF.shared.request(endpoint, method: .get, parameters: parameters, headers: nil) { result in
            targetVc.stopLoading()
            switch result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let session = try? decoder.decode(Session.self, from: data) {
                    completionHandler(session)
                } else {
                    completionHandler(nil)
                }
            case .failure(let error):
                print("error Login: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }
}
