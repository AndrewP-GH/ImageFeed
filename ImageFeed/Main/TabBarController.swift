//
// Created by Андрей Парамонов on 21.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func awakeFromNib() {
        super.awakeFromNib()

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let imageListVC = storyboard.instantiateViewController(withIdentifier: "ImageListViewController")
        let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")

        viewControllers = [imageListVC, profileVC]
    }
}

