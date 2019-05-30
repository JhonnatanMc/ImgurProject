//
//  ImageDetailViewControllerTest.swift
// ImageDetailViewControllerTest
//
//  Created by Jhonnatan Macias De La Puente on 5/21/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import XCTest

class ImageDetailViewControllerTest: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    func testInit() {
        app = XCUIApplication()
        let image = app.images["imageview"]
        XCTAssertTrue(image.exists)
    }

}
