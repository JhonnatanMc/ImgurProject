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

    override func unBind() {
        super.unBind()
    }

}

extension ImgurPresenter: ImgurPresenterProtocol {

    func bind(withView view: ImgurView) {
        super.bind(withView: view)
    }

    func isValidName(with imageTitle: String) {
        guard let view = self.view as? ImgurView else {
            return
        }

        let searchText = imageTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        guard !searchText.isEmpty else {
            view.cleanView()
            return
        }

//        searchPhotos(ImageName: searchText)
    }

    func searchPhotos(ImageName: String, isPrefetch: Bool) {
        currentPage = isPrefetch ? (currentPage + 1) : currentPage
        let page = String(currentPage)
        print(currentPage)
        WebServiceManager.sharedService.requestAPI(textSearch: ImageName, page: page) {  (JSON: Data?, status: Int) in
            do {
                if status == 200 {
                    let photosObject = try JSONDecoder().decode(Result.self, from: JSON!)
                    if isPrefetch {
                        self.photos.append(contentsOf: photosObject.data)
                    } else {
                        self.photos = photosObject.data
                    }

                    (self.view as? ImgurView)?.showPhotos(photosArr: self.photos)
                }
            } catch {
                print("Unable to reach server. Please check Internet connectivity and try again later.")
            }
        }
    }

    func isValidName(with imageTitle: String) -> Bool {
        return imageTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }


    func dismissKeyboard() {
        (self.view as? ImgurView)?.dismissKeyboard()
    }

    func cleanView() {
        currentPage = 0
        (self.view as? ImgurView)?.cleanView()
    }

}
