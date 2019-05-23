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
}

protocol ImgurPresenterProtocol: BasePresenterProtocol {

    func bind(withView view: ImgurView)

    func unBind()

    func removeLicense()

    func dismissKeyboard()

    func search(with imageTitle: String)
}
