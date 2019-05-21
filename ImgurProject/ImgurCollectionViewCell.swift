//
//  ImgurCollectionViewCell.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/21/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

class ImgurCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var photo: Photo? {
        didSet {
            if let photo = photo {
                pictureImageView.image = photo.image
                titleLabel.text = photo.caption
            }
        }
    }

}
