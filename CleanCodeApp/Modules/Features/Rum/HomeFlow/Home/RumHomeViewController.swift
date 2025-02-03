//
//  ViewController.swift
//  DeliveryAppChallenge
//
//  Created by Rodrigo Borges on 25/10/21.
//

import UIKit

class RumHomeViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)

        navigationItem.title = "Delivery App"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sair",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didClickLogOut))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func loadView() {
        self.view = HomeView()
    }

    @objc func didClickLogOut() {
        UserDefaultsManager.UserInfos.shared.delete()
        let storyboard = UIStoryboard(name: "RumUser", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RumLoginViewController") as! RumLoginViewController
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        window?.rootViewController = vc
        window?.makeKeyAndVisible()
    }
}

class RumHomeView: UIView {
}
