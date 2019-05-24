//
//  ImageDetailViewController.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit
import Alamofire

class ImageDetailViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var pictureImageView: UIImageView!

    // MARK: - Properties

    var image: Imgur?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let presenter = (presenter as? ImgurDetailPresenterProtocol), let imageDetail = image else {
            return
        }

        presenter.bind(withView: self)
        presenter.setTitle(image: imageDetail)
        presenter.getImage(image: imageDetail)
    }

}

// MARK: - ImgurDetailView extension

extension ImageDetailViewController: ImgurDetailView {

    func setPhoto(url: URL) {
        pictureImageView.af_setImage(withURL: url)
    }

    func showTitle(title: String) {
        self.title = title
    }

}
