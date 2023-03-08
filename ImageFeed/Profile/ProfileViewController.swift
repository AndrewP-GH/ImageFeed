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
//        setupFullNameLabel()
//        setupNicknameLabel()
//        setupDescriptionLabel()
//        setupLogoutButton()
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
        let person = UIImage(named: "Person")
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

    @objc private func didTapLogout() {
    }
}
