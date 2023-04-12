//
//  ProfileTests.swift
//  ImageFeedTests
//
//  Created by Андрей Парамонов on 12.04.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfilePresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        _ = viewController.view

        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }

    func testPresenterCallsUpdateProfile() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceSpy()
        profileService.profile = Profile(username: "user", name: "name", loginName: "login", bio: "bio")
        let profileImageService = ProfileImageServiceSpy()
        let presenter = ProfilePresenter(profileService: profileService, profileImageService: profileImageService)
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(viewController.updateProfileCalled)
    }

    func testPresenterCallsUpdateAvatar() {
        //given
        let viewController = ProfileViewControllerSpy()
        let profileService = ProfileServiceSpy()
        profileService.profile = Profile(username: "user", name: "name", loginName: "login", bio: "bio")
        let profileImageService = ProfileImageServiceSpy()
        profileImageService.avatarURL = "https://avatars.githubusercontent.com/u/1?v=4"
        let presenter = ProfilePresenter(profileService: profileService, profileImageService: profileImageService)
        viewController.presenter = presenter
        presenter.view = viewController

        //when
        presenter.viewDidLoad()

        //then
        XCTAssertTrue(viewController.updateAvatarCalled)
    }
}
