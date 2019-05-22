//
//  ImgurCollectionViewCell.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/21/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit
import Foundation
import AlamofireImage

class ImgurCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        let url = URL(string: "https://i.imgur.com/p8oFfsA.jpg")!
//   https://www.w3schools.com/w3css/img_lights.jpg https://i.imgur.com/p8oFfsA.jpg
        let placeholderImage = UIImage(named: "pattern")!
        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
            size: pictureImageView.frame.size,
            radius: 20.0
        )

        pictureImageView.af_setImage(
            withURL: url,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2)
        )

    }

    var photo: Photo? {
        didSet {
            if let photo = photo {
//                pictureImageView.image = photo.image
//                titleLabel.text = photo.caption
            }
        }
    }

}
