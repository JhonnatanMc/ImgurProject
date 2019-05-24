//
//  ImageDetailPresenter.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/24/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

class ImageDetailPresenter: BasePresenter {

    struct K {
        static let title = "Photo"
    }

    func titleView(image: Imgur) {
        guard let photo = image.images?.first else {
            return
        }

        let title = image.title ?? photo.title ?? photo.imageDescription ?? K.title
        (view as? ImgurDetailView)?.showTitle(title: title)
    }

}

extension ImageDetailPresenter: ImgurDetailPresenterProtocol {

    func bind(withView view: ImgurDetailView) {
        super.bind(withView: view)
    }

    func setTitle(image: Imgur) {
        titleView(image: image)
    }

    func getImage(image: Imgur) {
        guard let photoDetail = image.images?.first, let imageUrl = URL(string: photoDetail.link) else {
            return
        }

        (view as? ImgurDetailView)?.setPhoto(url: imageUrl)
    }

}
