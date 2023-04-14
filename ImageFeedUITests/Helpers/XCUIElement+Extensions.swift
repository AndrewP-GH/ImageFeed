//
//  XCUIElement+Extensions.swift
//  ImageFeedUITests
//
//  Created by Андрей Парамонов on 11.04.2023.
//

import XCTest

extension XCUIElement {
    func tapUnhittable() {
        XCTContext.runActivity(named: "Tap \(self) by coordinate") { _ in
            coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }
}
