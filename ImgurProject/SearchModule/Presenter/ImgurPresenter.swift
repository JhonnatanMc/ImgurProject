//
//  ImgurPresenter.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

class ImgurPresenter: BasePresenter {

    override func unBind() {
        super.unBind()
    }

//    func bind(withView view: ImgurView) {
//        super.bind(withView: view)
//        print("binding")
//    }

}

extension ImgurPresenter: ImgurPresenterProtocol {

    func removeLicense() {
        print("removing")
    }


    func bind(withView view: ImgurView) {
        super.bind(withView: view)
    }

    func dismissKeyboard() {
        (self.view as? ImgurView)?.dismissKeyboard()
    }

}
