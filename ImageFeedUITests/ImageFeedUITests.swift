//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Андрей Парамонов on 11.04.2023.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    private let app = XCUIApplication()

    private struct UserData {
        static let login = ""
        static let password = ""
        static let userName = "@paravoz"
        static let fullName = "Андрей Парамонов"
        static let description = "iOS Developer"
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))

        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        loginTextField.typeText(UserData.login)
        dismissKeyboardIfPresent()

        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
        passwordTextField.tap()
        passwordTextField.typeText(UserData.password)
        dismissKeyboardIfPresent()

        webView.buttons["Login"].tap()

        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }

    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))

        cell.swipeUp()
        sleep(2)
        print(app.debugDescription)

        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 4)
        print(cellToLike.debugDescription)

        let likeButton = cellToLike.buttons["Like"]
        likeButton.tap()
        sleep(5)
        print(app.debugDescription)
        let unlikeButton = cellToLike.buttons["Unlike"]
        XCTAssertTrue(unlikeButton.waitForExistence(timeout: 10))
        sleep(5)
        unlikeButton.tap()

        cellToLike.tap()
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 5))
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)

        let navBackButtonWhiteButton = app.buttons["Backward"]
        navBackButtonWhiteButton.tap()

        let cellToReturn = tablesQuery.children(matching: .cell).element(boundBy: 1)
        XCTAssertTrue(cellToReturn.waitForExistence(timeout: 5))
    }

    func testProfile() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
        let profile = app.tabBars.buttons.element(boundBy: 1)
        XCTAssertTrue(profile.waitForExistence(timeout: 5))
        profile.tap()

        let fullName = app.staticTexts["FullName"]
        XCTAssertEqual(UserData.fullName, fullName.label)
        let nickname = app.staticTexts["Nickname"]
        XCTAssertEqual(UserData.userName, nickname.label)
        let description = app.staticTexts["Description"]
        XCTAssertEqual(UserData.description, description.label)

        app.buttons["Logout"].tap()
        let alert = app.alerts["LogoutAlert"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        alert.scrollViews.otherElements.buttons["LogoutAlertYes"].tap()

        let authButton = app.buttons["Authenticate"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 5))
    }

    func dismissKeyboardIfPresent() {
        if app.keyboards.element(boundBy: 0).exists {
            if UIDevice.current.userInterfaceIdiom == .pad {
                app.keyboards.buttons["Hide keyboard"].tap()
            } else {
                app.toolbars.buttons["Done"].tap()
            }
        }
    }
}
