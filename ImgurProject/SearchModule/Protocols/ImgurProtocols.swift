//
//  ImgurProtocols.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation


protocol SearchInteractorResultProtocol {
    //Interactor -> Presenter
    func didFinishFetchingRecentSearchResults(allSearches: [Imgur]?)
}

protocol SearchInteractorProtocol {
    //Presenter -> Interactor
    var presenter: ImgurPresenter? { get set }

}
