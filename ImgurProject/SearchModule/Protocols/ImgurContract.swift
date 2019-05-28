//
//  ImgurContract.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

protocol ImgurView: BaseView {

    func dismissKeyboard()

    func cleanView()

    func showPhotos(photosArr: [Imgur])

    func displaySpinner()

    func hideSpinner()

    func getImageTitle() -> String?

    func getViewController() -> UIViewController
}

protocol ImgurPresenterProtocol: BasePresenterProtocol {

    var imgurInteractor: ImgurInteractor? {get set}

    func dismissKeyboard()

    func isValidName(with imageTitle: String) -> Bool

    func cleanView()

    func searchPhotos(ImageName: String, isPrefetch: Bool)

    func didSelectItem(image: Imgur, view: UIViewController)
}
