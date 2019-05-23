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

    @IBOutlet weak var pictureImageView: UIImageView!
    var image: Imgur?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let photo = image, let photoDetail = photo.images?.first else {
            return
        }

        guard let imageUrl = URL(string: photoDetail.link) else {
            return
        }

        pictureImageView.af_setImage(withURL: imageUrl)
        title = photo.title ??  photoDetail.title ?? photoDetail.imageDescription 
    }

}
