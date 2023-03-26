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
    private let oAuth2Service = OAuth2Service()

    private lazy var launchScreenImage: UIImageView = {
        let launchScreenImage = UIImageView()
        launchScreenImage.translatesAutoresizingMaskIntoConstraints = false
        launchScreenImage.image = UIImage(named: "LaunchScreen")
        launchScreenImage.contentMode = .scaleAspectFit
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
            showAuthViewController()
        }
    }

    private func showAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
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
        oAuth2Service.fetchAuthToken(code: code) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let token):
                self.tokenStorage.token = token
                self.fetchProfileAndSwitchScreen(token)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                UIBlockingProgressHUD.dismiss()
                SplashViewController.showNetworkErrorAlert(self.presentedViewController ?? self)
            }
        }
    }

    private func fetchProfileAndSwitchScreen(_ token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else {
                return
            }
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
