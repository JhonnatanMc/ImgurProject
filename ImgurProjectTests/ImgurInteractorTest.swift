//
//  ImgurInteractorTest.swift
//  ImgurProjectTests
//
//  Created by Jhonnatan Macias De La Puente on 5/29/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import XCTest
@testable import ImgurProject

class ImgurInteractorTest:  XCTestCase {

    private var interactor = ImgurInteractor()

    func testInit() {
        interactor.presenter = makePresenter()
        XCTAssertNotNil(interactor.presenter)
    }

    func testFetchRecentSearch() {
        XCTAssertNotNil(interactor)
        interactor.fetchRecentSearch(ImageName: "", page: "1")

        let getPhotosExpectation = expectation(description: "getSearchResult in ImgurInteractor should be called")

        interactor.getSearchResult(page: "cats", textSearch: "1") { (JSON: Data?, message, status) in
            getPhotosExpectation.fulfill()
        }

        interactor.fetchRecentSearch(ImageName: "cats", page: "1")

        waitForExpectations(timeout: 0.5) { error in
            guard let error = error else {
                return
            }

            XCTFail(getPhotosExpectation.description + " \(error)")
        }
    }

    func testIsValidName()  {
        XCTAssert(!interactor.isValidName(with: "Cats"))
    }

    func makePresenter() ->ImgurPresenter {
        return ImgurPresenter(imgurInteractor: ImgurInteractor(), imgurRouteWireframe: ImgurRouteWireFrame())
    }

}
