//
//  ImgurViewControllerTest.swift
//  ImgurProjectUITests
//
//  Created by Jhonnatan Macias De La Puente on 5/30/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import XCTest

class ImgurViewControllerTest: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    func testInit() {
        app = XCUIApplication()
        let image = app.collectionViews["collectionView"]
        let searchYourImageSearchField = app.searchFields["Search your Image"]
        let cancelButton = app.buttons["Cancel"]
        searchYourImageSearchField.tap()
        app.buttons["Cancel"].tap()
        searchYourImageSearchField.tap()
        app.otherElements.containing(.navigationBar, identifier:"Imgur").children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).tap()
        searchYourImageSearchField.typeText("cats")

        XCTAssertTrue(image.exists)
        XCTAssertTrue(cancelButton.exists)
        XCTAssertTrue(searchYourImageSearchField.exists)
        searchYourImageSearchField.waitForExistence(timeout: 0.5)
    }


}
