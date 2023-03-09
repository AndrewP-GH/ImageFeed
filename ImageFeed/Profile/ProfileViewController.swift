//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 24.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {

    private var personImage: UIImageView!
    private var fullNameLabel: UILabel!
    private var nicknameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var logoutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPersonImage()
        setupLogoutButton()
        setupFullNameLabel()
        setupNicknameLabel()
        setupDescriptionLabel()
    }

    private func setupPersonImage() {
        personImage = UIImageView()
        personImage.translatesAutoresizingMaskIntoConstraints = false
        personImage.image = getPersonImage()
        personImage.contentMode = .scaleAspectFit
        view.addSubview(personImage)
        personImage.widthAnchor.constraint(equalToConstant: 70).isActive = true
        personImage.heightAnchor.constraint(equalToConstant: 70).isActive = true
        personImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        personImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }

    private func getPersonImage() -> UIImage {
        let person = UIImage(named: "StubPhoto")
        if person != nil {
            return person!
        } else {
            let systemName = "person.crop.circle.fill"
            if #available(iOS 15.0, *) {
                let config = UIImage.SymbolConfiguration(paletteColors: [.ypWhite, .ypGrey])
                return UIImage(systemName: systemName, withConfiguration: config)!
            } else {
                return UIImage(systemName: systemName)!
            }
        }
    }

    private func setupLogoutButton() {
        logoutButton = UIButton.systemButton(
                with: UIImage(named: "Logout")!,
                target: self,
                action: #selector(didTapLogout))
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.tintColor = .ypRed
        view.addSubview(logoutButton)
        logoutButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: personImage.centerYAnchor).isActive = true
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26).isActive = true
    }

    private func setupFullNameLabel() {
        fullNameLabel = UILabel()
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.text = "Екатерина Новикова"
        fullNameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)   // bold (700)
        fullNameLabel.textColor = .ypWhite
        view.addSubview(fullNameLabel)
        fullNameLabel.topAnchor.constraint(equalTo: personImage.bottomAnchor, constant: 8).isActive = true
        fullNameLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor).isActive = true
        fullNameLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor).isActive = true
    }

    private func setupNicknameLabel() {
        nicknameLabel = UILabel()
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        nicknameLabel.text = "@ekaterina_nov"
        nicknameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)   // regular (400)
        nicknameLabel.textColor = .ypGrey
        view.addSubview(nicknameLabel)
        nicknameLabel.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 8).isActive = true
        nicknameLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor).isActive = true
        nicknameLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor).isActive = true
    }

    private func setupDescriptionLabel() {
        descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)   // regular (400)
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.numberOfLines = 0
        view.addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: personImage.leadingAnchor).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: logoutButton.trailingAnchor).isActive = true
    }

    @objc private func didTapLogout() {
    }
}
