//
//  ImgurDetailContract.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/24/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

protocol ImgurDetailView: BaseView {

    func showTitle(title: String)

    func setPhoto(url: URL)

}

protocol ImgurDetailPresenterProtocol: BasePresenterProtocol {

    func bind(withView view: ImgurDetailView)

    func unBind()

    func setTitle(image: Imgur)

    func getImage(image: Imgur)

}
