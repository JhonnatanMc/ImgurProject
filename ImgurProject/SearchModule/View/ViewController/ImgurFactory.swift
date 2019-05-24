//
//  ImgurFactory.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/24/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

class ImgurFactory {

    static func makeImgurPresenter() -> ImgurPresenter {
        return ImgurPresenter(imgurInteractor: ImgurInteractor(), imgurRouteWireframe: ImgurRouteWireFrame())
    }

    static func makeDetailViewController() -> ImageDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageDetailView = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        imageDetailView.presenter = ImageDetailPresenter()
        return imageDetailView
    }

}
