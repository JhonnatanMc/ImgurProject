//
//  ImgurProjectTests.swift
//  ImgurProjectTests
//
//  Created by Jhonnatan Macias De La Puente on 5/21/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import XCTest
@testable import ImgurProject

class ImgurProjectTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWireFrame() {
        // ImgurViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImgurViewController")  as? ImgurViewController
//        viewController?.presenter = ImgurPresenter(imgurInteractor: <#ImgurInteractor#>)
        XCTAssertNotNil(viewController)
//        XCTAssertNotNil(viewController?.presenter)

    }

    func testDetailView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageDetailView = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        imageDetailView.presenter = ImageDetailPresenter()
        XCTAssertNotNil(imageDetailView)
        XCTAssertNotNil(imageDetailView.presenter)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
