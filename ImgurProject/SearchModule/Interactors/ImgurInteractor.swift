//
//  ImgurInteractor.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

class ImgurInteractor: SearchInteractorProtocol, WebServiceManagerProtocol {

    var presenter: ImgurPresenter?


    func fetchRecentSearch(ImageName: String, page: String) {
        guard !isValidName(with: ImageName) else {
            return
        }

        let request = RequestWithSessionDelegate()
        request.requestWithSessionDelegate()

//        self.dataTask()


//        DispatchQueue.main.async { [weak self] in
//            self?.getSearchResult(page: page, textSearch: ImageName) { [weak self] (JSON: Data?, message, status) in
//                guard let data = JSON else {
//                    return
//                }
//
//                do {
//                    if status == BaseUrl.statusCode.success.rawValue {
//                        let photosObject = try JSONDecoder().decode(Result.self, from: data)
//                        self?.presenter?.didFinishFetchingRecentSearchResults(allSearches: photosObject.data)
//                    }
//                } catch {
//                    self?.presenter?.didFinishFetchingRecentSearchResults(allSearches: nil)
//                }
//            }
//        }
    }

    func isValidName(with imageTitle: String) -> Bool {
        return imageTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
}
