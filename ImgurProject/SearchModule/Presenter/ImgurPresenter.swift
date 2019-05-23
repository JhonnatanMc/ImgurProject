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

    override func unBind() {
        super.unBind()
    }

    func searchPhotos(ImageName: String) {
        let page = String((currentPage+1))
        WebServiceManager.sharedService.requestAPI(textSearch: ImageName, page: page) {  (JSON: Data?, status: Int) in
            do {
                if status == 200 {
                    let photosObject = try JSONDecoder().decode(Result.self, from: JSON!)
                    (self.view as? ImgurView)?.showPhotos(photosArr: photosObject.data)
                }
            } catch {
                print("Unable to reach server. Please check Internet connectivity and try again later.")
            }
        }
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

        searchPhotos(ImageName: searchText)
    }

    func dismissKeyboard() {
        (self.view as? ImgurView)?.dismissKeyboard()
    }

    func cleanView() {
        currentPage = 0
        (self.view as? ImgurView)?.cleanView()
    }

}
