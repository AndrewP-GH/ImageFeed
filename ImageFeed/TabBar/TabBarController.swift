//
// Created by Андрей Парамонов on 21.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundColor
        tabBar.tintColor = .ypWhite
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .backgroundColor
        tabBar.standardAppearance = appearance

        let imageListVC = ImagesListViewController()
        let imageListPresenter = ImagesListPresenter(imagesListService: ImagesListService(),
                                                    dateFormatter: ImageDateFormatter())
        imageListPresenter.view = imageListVC
        imageListVC.presenter = imageListPresenter
        imageListVC.tabBarItem = UITabBarItem(title: nil,
                                              image: UIImage(named: "tab_editorial_active"),
                                              selectedImage: nil)
        let profileVC = ProfileViewController()
        let profilePresenter = ProfilePresenter(profileService: ProfileService.shared,
                                                profileImageService: ProfileImageService.shared)
        profilePresenter.view = profileVC
        profileVC.presenter = profilePresenter
        profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        viewControllers = [imageListVC, profileVC]
    }
}

