//
//  ImgurInteractor.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

class ImgurInteractor: SearchInteractorProtocol {

    var presenter: ImgurPresenter?

    func fetchRecentSearch(ImageName: String, page: String) {
        WebServiceManager.sharedService.requestAPI(textSearch: ImageName, page: page) {  [weak self] (JSON: Data?, status: Int) in
            do {
                if status == 200 {
                    let photosObject = try JSONDecoder().decode(Result.self, from: JSON!)
                    self?.presenter?.didFinishFetchingRecentSearchResults(allSearches: photosObject.data)
                } else {
                    self?.presenter?.didFinishFetchingWithError()
                }
            } catch {
                self?.presenter?.didFinishFetchingRecentSearchResults(allSearches: nil)
            }
        }
    }
}
