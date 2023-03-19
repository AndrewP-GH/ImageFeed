//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 24.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?

    private lazy var personImage: UIImageView = {
        let personImage = UIImageView()
        personImage.translatesAutoresizingMaskIntoConstraints = false
        personImage.image = ProfileViewController.getPersonImage()
        personImage.contentMode = .scaleAspectFit
        return personImage
    }()
    private lazy var fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)   // bold (700)
        fullNameLabel.textColor = .ypWhite
        return fullNameLabel
    }()
    private lazy var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)   // regular (400)
        nicknameLabel.textColor = .ypGrey
        return nicknameLabel
    }()
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)   // regular (400)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton.systemButton(
                with: UIImage(named: "Logout")!,
                target: self,
                action: #selector(didTapLogout))
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.tintColor = .ypRed
        return logoutButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        profileImageServiceObserver = NotificationCenter.default
                .addObserver(
                        forName: ProfileImageService.DidChangeNotification,
                        object: self,
                        queue: .main
                ) { [weak self] notification in
                    self?.updateAvatar()
                }

        addSubViews()
        applyConstraints()
        guard let profile = profileService.profile else {
            assertionFailure("Profile is not loaded")
            return
        }
        updateProfileDetails(profile: profile)
        updateAvatar()
    }

    private func updateAvatar() {
        if let avatarUrl = profileImageService.avatarURL,
           let imageUrl = URL(string: avatarUrl) {

        }
    }

    private func addSubViews() {
        view.addSubview(personImage)
        view.addSubview(logoutButton)
        view.addSubview(fullNameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(descriptionLabel)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate(
                [
                    personImage.widthAnchor.constraint(equalToConstant: 70),
                    personImage.heightAnchor.constraint(equalToConstant: 70),
                    personImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
                    personImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                    logoutButton.widthAnchor.constraint(equalToConstant: 20),
                    logoutButton.heightAnchor.constraint(equalToConstant: 22),
                    logoutButton.centerYAnchor.constraint(equalTo: personImage.centerYAnchor),
                    logoutButton.trailingAnchor
                            .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
                    fullNameLabel.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 8),
                    fullNameLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor),
                    fullNameLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
                    nicknameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8),
                    nicknameLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor),
                    nicknameLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
                    descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
                    descriptionLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor),
                    descriptionLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor),
                ]
        )
    }

    private func updateProfileDetails(profile: Profile) {
        fullNameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }

    private static func getPersonImage() -> UIImage {
        let systemName = "person.crop.circle.fill"
        if #available(iOS 15.0, *) {
            let config = UIImage.SymbolConfiguration(paletteColors: [.ypWhite, .ypGrey])
            return UIImage(systemName: systemName, withConfiguration: config)!
        } else {
            return UIImage(systemName: systemName)!
        }
    }

    @objc private func didTapLogout() {
        UserDefaults.standard.removeObject(forKey: "authToken") //TODO: Remove hack
    }
}
