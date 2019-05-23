//
//  ImageLayoutDelegate.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias on 5/21/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

protocol ImageLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat
}
