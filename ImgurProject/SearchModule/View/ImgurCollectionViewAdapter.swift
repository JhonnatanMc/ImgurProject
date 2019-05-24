//
//  ImgurCollectionViewAdapter.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/24/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

class ImgurCollectionViewAdapter: CollectionViewAdapter<Imgur> {

    struct K {
        static let lastTenVisibleCells = 10
        static let maxPhotoHeight: CGFloat = 200
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgurCollectionViewCell", for: indexPath)
            as? ImgurCollectionViewCell else {
                return UICollectionViewCell()
        }

        cell.configureCell(imgur: data[indexPath.row])
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if  indexPath.item > (data.count - K.lastTenVisibleCells) {
                self.prefetchListener?.prefetchData()
            }
        }
    }

}


extension ImgurCollectionViewAdapter: ImageLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        guard let imageHeight = data[indexPath.item].images?.first?.height else {
            return K.maxPhotoHeight
        }

        return CGFloat(imageHeight)
    }

}
