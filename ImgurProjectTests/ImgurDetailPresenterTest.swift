//
//  ImgurDetailPresenterTest.swift
//  ImgurProjectTests
//
//  Created by Jhonnatan Macias De La Puente on 5/30/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import XCTest
@testable import ImgurProject

class ImgurDetailPresenterTest: XCTestCase {

    private var presenter: ImageDetailPresenter!
    private var view: ImageDetailViewController!

    func testInit() {
        presenter = makePresenter()
        XCTAssertNotNil(presenter)
    }

    func testValidView() {
        presenter = makePresenter()
        view = imageDetailViewController(presenter: presenter)
        view.beginAppearanceTransition(true, animated: false)
        view.endAppearanceTransition()
        presenter.set(withView: view)
        XCTAssertNotNil(view)
    }

    func testTitleView() {
        testValidView()
        let image = makeFakeModel()
        let showTitleExpetaction = expectation(description: "show title in Presenter should be called")
        XCTAssertNotNil(image)

        guard let title = image.title else {
            XCTFail("Photo without title")
            return
        }

        view.showTitle(title: title)
        showTitleExpetaction.fulfill()

        presenter.titleView(image: image)

        waitForExpectations(timeout: 0.1) { error in
            guard let error = error else {
                return
            }

            XCTFail(showTitleExpetaction.description + " \(error)")
        }
    }

        func testSetTitle() {
            testValidView()
            let image = makeFakeModel()
            let setTitleExpetaction = expectation(description: "setTitle in Presenter should be called")
            presenter.setTitle(image: image)
            setTitleExpetaction.fulfill()
            presenter.setTitle(image: image)
            XCTAssertNotNil(image)

            waitForExpectations(timeout: 0.1) { error in
                guard let error = error else {
                    return
                }

                XCTFail(setTitleExpetaction.description + " \(error)")
            }
    }


    func testSetPhoto() {
        testValidView()
        let image = makeFakeModel()
        view.loadViewIfNeeded()
        let setPhotoExpectation = expectation(description: "getImage in presenter should be called")

        guard let photoDetail = image.images?.first, let imageUrl = URL(string: photoDetail.link) else {
            XCTFail("set photo doesn't have link")
            return
        }
        view.setPhoto(url: imageUrl)
        setPhotoExpectation.fulfill()
        presenter.getImage(image: image)

        waitForExpectations(timeout: 0.5) { error in
            guard let error = error else {
                return
            }

            XCTFail(setPhotoExpectation.description + " \(error)")
        }

    }


    func makePresenter() -> ImageDetailPresenter {
        let presenter = ImageDetailPresenter()
        return presenter
    }

    func imageDetailViewController(presenter: ImageDetailPresenter) -> ImageDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController")  as! ImageDetailViewController
        viewController.presenter = presenter
        return viewController
    }

    func makeFakeModel() -> Imgur {
        var image = Imgur()
        let photo: Image = {
            var photo = Image()
            photo.link = "https://www.w3schools.com/w3css/img_lights.jpg"
            photo.title = "cat"
            photo.imageDescription = "cat"
            image.title = "Cats"
            return photo
        }()

        image.images = [photo]
        return image
    }
}

