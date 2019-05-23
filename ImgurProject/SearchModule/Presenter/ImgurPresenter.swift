//
//  ImgurPresenter.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

class ImgurPresenter: BasePresenter {

    private var currentPage = 0
    private var photos = [Imgur]()
    private var isPrefetch: Bool = false

    var imgurInteractor: ImgurInteractor?

    override func unBind() {
        super.unBind()
    }

    required init(imgurInteractor: ImgurInteractor) {
        super.init()
        self.imgurInteractor = imgurInteractor
        self.loadSearchPageComponents()
    }

}

extension ImgurPresenter: ImgurPresenterProtocol {

    func loadSearchPageComponents() {
        imgurInteractor?.presenter = self
    }

    func bind(withView view: ImgurView) {
        super.bind(withView: view)
    }

    func searchPhotos(ImageName: String, isPrefetch: Bool) {
        currentPage = isPrefetch ? (currentPage + 1) : currentPage
        let page = String(currentPage)
        self.isPrefetch = isPrefetch
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

extension ImgurPresenter: SearchInteractorResultProtocol {

    func didFinishFetchingRecentSearchResults(allSearches: [Imgur]?) {
        guard let AllPhotos = allSearches else {
            return
        }

        if isPrefetch {
            self.photos.append(contentsOf: AllPhotos)
        } else {
            photos = AllPhotos
        }

        (self.view as? ImgurView)?.showPhotos(photosArr: photos)

    }

}
