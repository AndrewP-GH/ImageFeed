//
// Created by Андрей Парамонов on 12.04.2023.
//

import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func logout()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    private let profileService: ProfileServiceProtocol
    private let profileImageService: ProfileImageServiceProtocol
    private var profileImageServiceObserver: NSObjectProtocol?
    weak var view: ProfileViewControllerProtocol?

    init(profileService: ProfileServiceProtocol, profileImageService: ProfileImageServiceProtocol) {
        self.profileService = profileService
        self.profileImageService = profileImageService
    }

    func viewDidLoad() {
        if profileImageServiceObserver == nil {
            profileImageServiceObserver = NotificationCenter.default
                    .addObserver(
                            forName: ProfileImageService.didChangeNotification,
                            object: nil,
                            queue: .main
                    ) { [weak self] notification in
                        self?.updateAvatar()
                    }
        }
        guard let profile = profileService.profile else {
            return
        }
        view?.updateProfile(with: profile)
        updateAvatar()
    }

    func logout() {
        let alert = UIAlertController(
                title: "Пока, пока!",
                message: "Уверены что хотите выйти?",
                preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "LogoutAlert"

        let yes = UIAlertAction(title: "Да", style: .default) { _ in
            OAuth2TokenStorage().token = nil
            CookieHelper.cleanAll()
            let window = UIApplication.shared.windows.first!
            window.rootViewController = SplashViewController()
            window.makeKeyAndVisible()
        }
        yes.accessibilityIdentifier = "LogoutAlertYes"

        let no = UIAlertAction(title: "Нет", style: .default)
        no.accessibilityIdentifier = "LogoutAlertNo"

        alert.addAction(yes)
        alert.addAction(no)
        alert.preferredAction = no
        view?.present(alert, animated: true)
    }

    private func updateAvatar() {
        if let avatarUrl = profileImageService.avatarURL,
           let imageUrl = URL(string: avatarUrl) {
            view?.updateAvatar(with: imageUrl)
        }
    }
}
