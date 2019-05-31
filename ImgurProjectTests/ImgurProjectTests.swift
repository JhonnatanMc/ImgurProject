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

}
