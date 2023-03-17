//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 12.03.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let tokenStorage = OAuth2TokenStorage()
    private weak var authNavigationController: UINavigationController?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if tokenStorage.token == nil {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        } else {
            switchToTabBarController()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            guard let navigationController = segue.destination as? UINavigationController,
                  let authController = navigationController.viewControllers[0] as? AuthViewController else {
                assertionFailure("Failed to prepare for segue \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            authNavigationController = navigationController
            authController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        let tabBarViewController = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(identifier: "TabBarViewController")
        window.rootViewController = tabBarViewController
        window.makeKeyAndVisible()
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        authNavigationController?.popToRootViewController(animated: true)
        ProgressHUD.show()
        DispatchQueue.global().async {
            self.fetchOAuthToken(code)
        }
    }

    private func fetchOAuthToken(_ code: String) {
        OAuth2Service().fetchAuthToken(code: code) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self else {
                    return
                }
                switch result {
                case .success(let token):
                    self.tokenStorage.token = token
                    ProgressHUD.dismiss()
                    self.switchToTabBarController()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
