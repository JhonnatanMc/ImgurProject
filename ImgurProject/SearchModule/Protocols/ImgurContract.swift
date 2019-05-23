//
//  ImgurContract.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation


protocol ImgurView: BaseView {

    func dismissKeyboard()

    func cleanView()

    func showPhotos(photosArr: [Imgur])
}

protocol ImgurPresenterProtocol: BasePresenterProtocol {

    var imgurInteractor: ImgurInteractor? {get set}

    func bind(withView view: ImgurView)

    func unBind()

    func dismissKeyboard()

    func isValidName(with imageTitle: String) -> Bool

    func cleanView()

    func searchPhotos(ImageName: String, isPrefetch: Bool)
}
