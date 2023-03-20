//
// Created by Андрей Парамонов on 21.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListVC = storyboard.instantiateViewController(withIdentifier: "ImageListViewController")
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        profileVC.view.backgroundColor = .ypBlack

        viewControllers = [imageListVC, profileVC]
    }
}

