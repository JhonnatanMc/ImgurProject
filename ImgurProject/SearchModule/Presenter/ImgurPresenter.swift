//
//  ImgurPresenter.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

class ImgurPresenter: BasePresenter {

    private var currentPage = 0

    override func unBind() {
        super.unBind()
    }




}

extension ImgurPresenter: ImgurPresenterProtocol {

    func removeLicense() {
        print("removing")
    }

    func bind(withView view: ImgurView) {
        super.bind(withView: view)
    }

    func isValidName(with imageTitle: String) {
        guard let view = self.view as? ImgurView else {
            return
        }

        let searchText = imageTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        guard !searchText.isEmpty else {
            view.cleanView()
            return
        }

    }

    func dismissKeyboard() {
        (self.view as? ImgurView)?.dismissKeyboard()
    }

    func cleanView() {
        (self.view as? ImgurView)?.cleanView()
    }

}
