//
//  ImgurPresenter.swift
//  ImgurPresenterTest
//
//  Created by Jhonnatan Macias De La Puente on 5/29/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import XCTest
@testable import ImgurProject

class ImgurPresenterTest: XCTestCase {

    private var presenter: ImgurPresenter!
    private var interactor = ImgurInteractor()
    private var view: ImgurViewController!
    private var wireFrame = ImgurRouteWireFrame()

    func testInit() {
        presenter = makePresenter()
        XCTAssertNotNil(presenter)
    }

    func testDidSelectItem() {
        presenter = makePresenter()
        let image = Imgur()
        let detailImageExpectation = expectation(description: "didSelectItem in Presenter should be called")
        presenter?.didSelectItem(image: image, view: UIViewController())
        detailImageExpectation.fulfill()

        waitForExpectations(timeout: 0.3) { (error) in
            guard let error = error else {
                return
            }

            XCTFail(detailImageExpectation.description + " \(error)")
        }
    }

    func testSearchPhotos() {
        testValidView()
        let fetchRecentSearchExpectation = expectation(description: "fetchRecentSearch in Presenter should be called")
        interactor.fetchRecentSearch(ImageName: "cats", page: "1")

        DispatchQueue.main.async {
            fetchRecentSearchExpectation.fulfill()
        }

        view.loadView()
        view.displaySpinner()
        presenter.searchPhotos(ImageName: "cats", isPrefetch: false)

        waitForExpectations(timeout: 0.4) { error in
            guard let error = error else {
                return
            }

            XCTFail(fetchRecentSearchExpectation.description + " \(error)")
        }

    }

    func testIsValidName() {
        presenter = makePresenter()
        XCTAssertFalse(presenter.isValidName(with: "cats"))
    }

    func testValidView() {
        presenter = makePresenter()
        view = imgurViewController(presenter: presenter)
        view.beginAppearanceTransition(true, animated: false)
        view.endAppearanceTransition()
        presenter.set(withView: view)
        XCTAssertNotNil(view)
    }

    func testDismissKeyboard() {
        testValidView()
        presenter.dismissKeyboard()
    }

    func testCleanView() {
        testValidView()
        let cleanExpectation = expectation(description: "cleanView in Presenter should be called")
        view.loadView()
        view.cleanView()
        cleanExpectation.fulfill()
        presenter.cleanView()

        waitForExpectations(timeout: 0.2) { error in
            guard let error = error else {
                return
            }

            XCTFail(cleanExpectation.description + " \(error)")
        }

    }

    func imgurViewController(presenter: ImgurPresenter) -> ImgurViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImgurViewController")  as! ImgurViewController
        viewController.presenter = presenter
        return viewController
    }

    func makePresenter() -> ImgurPresenter {
        let presenter = ImgurPresenter(imgurInteractor: interactor, imgurRouteWireframe: wireFrame)
        presenter.imgurInteractor = interactor
        return presenter
    }

}


