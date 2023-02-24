//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Андрей Парамонов on 24.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private var PersonImage: UIImageView!
    @IBOutlet private var FullNameLabel: UILabel!
    @IBOutlet private var NicknameLabel: UILabel!
    @IBOutlet private var DescriptionLabel: UILabel!
    @IBOutlet private var LogoutButton: UIButton!
    
    @IBAction private func didTapLogout() {
    }
}
