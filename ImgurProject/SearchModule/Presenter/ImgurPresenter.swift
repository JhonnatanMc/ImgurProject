//
//  ImgurPresenter.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

class ImgurPresenter: BasePresenter {

    // MARK: - Properties

    private var currentPage = 0
    private var photos = [Imgur]()
    private var isPrefetch: Bool = false
    var imgurInteractor: ImgurInteractor?
    var imgurRouteWireframe: ImgurRouteWireFrame?

    // MARK: - Initializers

    required init(imgurInteractor: ImgurInteractor, imgurRouteWireframe: ImgurRouteWireFrame) {
        super.init()
        self.imgurInteractor = imgurInteractor
        self.imgurRouteWireframe = imgurRouteWireframe
        self.loadComponents()
    }

    override func unBind() {
        super.unBind()
    }

}

// MARK: - ImgurPresenterProtocol

extension ImgurPresenter: ImgurPresenterProtocol {

    func didSelectItem(image: Imgur, view: UIViewController) {
        imgurRouteWireframe?.showImageDetails(image: image, from: view)
    }

    func loadComponents() {
        imgurInteractor?.presenter = self
    }

    func bind(withView view: ImgurView) {
        super.bind(withView: view)
    }

    func searchPhotos(ImageName: String, isPrefetch: Bool) {
        currentPage = isPrefetch ? (currentPage + 1) : currentPage
        let page = String(currentPage)
        self.isPrefetch = isPrefetch
        (view as? ImgurView)?.displaySpinner()
        imgurInteractor?.fetchRecentSearch(ImageName: ImageName, page: page)
    }

    func isValidName(with imageTitle: String) -> Bool {
        return imageTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }

    func dismissKeyboard() {
        (self.view as? ImgurView)?.dismissKeyboard()
    }

    func cleanView() {
        currentPage = 0
        photos = [Imgur]()
        isPrefetch = false
        (self.view as? ImgurView)?.cleanView()
    }

}

// MARK: - SearchInteractorResultProtocol

extension ImgurPresenter: SearchInteractorResultProtocol {

    func didFinishFetchingWithError() {
        (view as? ImgurView)?.hideSpinner()
        cleanView()
    }

    func didFinishFetchingRecentSearchResults(allSearches: [Imgur]?) {
        guard let AllPhotos = allSearches else {
            return
        }

        if isPrefetch {
            self.photos.append(contentsOf: AllPhotos)
        } else {
            photos = AllPhotos
        }

        (view as? ImgurView)?.hideSpinner()
        (self.view as? ImgurView)?.showPhotos(photosArr: photos)
    }

}

// MARK: - onCellTouchListener

extension ImgurPresenter: onCellTouchListener {

    func onCellTouch<Cell>(_ cell: Cell, object: Any) where Cell: UICollectionViewCell {
        guard let view = (view as? ImgurView), let photo = (object as? Imgur) else {
            return
        }

        didSelectItem(image: photo, view: view.getViewController())
    }
}

// MARK: - CollectionViewPrefetchListener

extension ImgurPresenter: CollectionViewPrefetchListener {

    func prefetchData() {
        guard let view = (view as? ImgurView), let photoTitle = view.getImageTitle() else {
            return
        }

        let isValidText = isValidName(with: photoTitle)

        guard !isValidText else {
            return
        }

        searchPhotos(ImageName: photoTitle, isPrefetch: true)
    }

}
