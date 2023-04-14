//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Андрей Парамонов on 12.04.2023.
//

@testable import ImageFeed
import UIKit
import XCTest

final class ProfileViewControllerSpy: UIViewController, ProfileViewControllerProtocol {
    var presenter: ProfilePresenterProtocol?
    var updateProfileCalled: Bool = false
    var updateAvatarCalled: Bool = false

    func updateProfile(with profile: ImageFeed.Profile) {
        updateProfileCalled = true
    }

    func updateAvatar(with url: URL) {
        updateAvatarCalled = true
    }
}
