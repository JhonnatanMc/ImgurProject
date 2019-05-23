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
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        pictureImageView.image = nil
        titleLabel.text = ""
    }

    func configureCell(imgur: Imgur) {
        guard let image = imgur.images?.first else {
            return
        }

        titleLabel.text = imgur.title ?? image.imageDescription ??  image.title 

        let filter = AspectScaledToFillSizeWithRoundedCornersFilter(size: pictureImageView.frame.size, radius: 4)
        let placeholderImage = UIImage(named: "placeholder")!

        guard let imageUrl = URL(string: image.link) else {
            return
        }

        pictureImageView.af_setImage(
            withURL: imageUrl,
            placeholderImage: placeholderImage,
            filter: filter,
            imageTransition: .crossDissolve(0.2)
        )
    }

}
