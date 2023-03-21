//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 12.03.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private weak var authViewController: AuthViewController?

    private var launchScreenImage: UIImageView = {
        let launchScreenImage = UIImageView()
        launchScreenImage.image = UIImage(named: "LaunchScreen")
        launchScreenImage.contentMode = .scaleAspectFit
        launchScreenImage.translatesAutoresizingMaskIntoConstraints = false
        return launchScreenImage
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .backgroundColor
        addSubviews()
        setupConstraints()
    }

    private func addSubviews() {
        view.addSubview(launchScreenImage)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate(
                [
                    launchScreenImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                    launchScreenImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                ]
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = tokenStorage.token {
            fetchProfileAndSwitchScreen(token)
        } else {
            let authViewController = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(identifier: "AuthViewController") as! AuthViewController
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.authViewController = authViewController
            present(authViewController, animated: true)
        }
    }

    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid Configuration")
            return
        }
        let tabBarViewController = TabBarController()
        window.rootViewController = tabBarViewController
        window.makeKeyAndVisible()
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        vc.dismiss(animated: true)
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
                SplashViewController.showNetworkErrorAlert(self.authViewController ?? self)
            }
        }
    }

    private func fetchProfileAndSwitchScreen(_ token: String) {
        profileService.fetchProfile(token) { result in
            switch result {
            case .success(let profile):
                self.profileImageService.fetchProfileImageURL(username: profile.username) { _ in
                }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure(let error):
                debugPrint(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
                SplashViewController.showNetworkErrorAlert(self)
            }
        }
        switchToTabBarController()
    }

    private static func showNetworkErrorAlert(_ vc: UIViewController) {
        let alert = UIAlertController(title: "Что-то пошло не так(",
                                      message: "Не удалось войти в систему",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
}
