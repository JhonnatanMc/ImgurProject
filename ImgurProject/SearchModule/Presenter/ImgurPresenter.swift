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

    private var currentPage = 1
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

    override func unSet() {
        super.unSet()
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

    func set(withView view: ImgurView) {
        super.set(withView: view)
    }

    func searchPhotos(ImageName: String, isPrefetch: Bool) {
        currentPage = isPrefetch ? (currentPage + 1) : currentPage
        let page = String(currentPage)
        self.isPrefetch = isPrefetch

        guard let view = (view as? ImgurView) else {
            return
        }

        view.displaySpinner()
        imgurInteractor?.fetchRecentSearch(ImageName: ImageName, page: page)
    }

    func isValidName(with imageTitle: String) -> Bool {
        return imageTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }

    func dismissKeyboard() {
        guard let view = (view as? ImgurView) else {
            return
        }

        view.dismissKeyboard()
    }

    func cleanView() {
        currentPage = 0
        photos = [Imgur]()
        isPrefetch = false

        guard let view = (view as? ImgurView) else {
            return
        }

        view.cleanView()
    }

}

// MARK: - SearchInteractorResultProtocol

extension ImgurPresenter: SearchInteractorResultProtocol {

    func didFinishFetchingWithError() {
        DispatchQueue.main.async { [weak self] in
            guard let view = (self?.view as? ImgurView) else {
                return
            }

            view.hideSpinner()
            self?.cleanView()
        }
    }

    func didFinishFetchingRecentSearchResults(allSearches: [Imgur]?) {
        DispatchQueue.main.async { [weak self] in

            guard let AllPhotos = allSearches, let isPrefetched = self?.isPrefetch,
                let view = (self?.view as? ImgurView) else {
                return
            }

            if isPrefetched {
                self?.photos.append(contentsOf: AllPhotos)
            } else {
                self?.photos = AllPhotos
            }

            view.hideSpinner()

            guard let photos = self?.photos else {
                return
            }

            view.showPhotos(photosArr: photos)
        }
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

        searchPhotos(ImageName: photoTitle, isPrefetch: true)
    }

}
