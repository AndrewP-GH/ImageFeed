//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 12.03.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared

    private weak var authNavigationController: UINavigationController?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = tokenStorage.token {
            fetchProfileAndSwitchScreen(token)
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
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
        UIBlockingProgressHUD.show()
        fetchOAuthToken(code)
    }

    private func fetchOAuthToken(_ code: String) {
        OAuth2Service().fetchAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                self.tokenStorage.token = token
                self.fetchProfileAndSwitchScreen(token)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }

    private func fetchProfileAndSwitchScreen(_ token: String) {
        profileService.fetchProfile(token) { result in
            defer {
                UIBlockingProgressHUD.dismiss()
            }
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in
                }
                self.switchToTabBarController()
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
}
