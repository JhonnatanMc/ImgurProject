//
//  CollectionViewAdapter.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/24/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit
import Foundation

class CollectionViewAdapter<T: Any>: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {

    // MARK: - Properties

    weak var collectionView: UICollectionView?
    weak var onCellTouchListener: onCellTouchListener?
    weak var prefetchListener: CollectionViewPrefetchListener?
    var data: [T]

    // MARK: - Initializers

    init(collectionView: UICollectionView, data: [T] = [],
         onCellTouchListener: onCellTouchListener? = nil, prefetchListener: CollectionViewPrefetchListener? = nil) {
        self.data = data
        self.collectionView = collectionView
        self.onCellTouchListener = onCellTouchListener
        self.prefetchListener = prefetchListener
        super.init()
        setUpAdapter()
    }

    // MARK: - Public Methods

    func addData(data: [T]) {
        self.data = data
        notifyDataSetHasChanged()
    }

    func clear() {
        data = []
        notifyDataSetHasChanged()
    }

    func notifyDataSetHasChanged() {
        collectionView?.reloadData()
        collectionView?.collectionViewLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            onCellTouchListener?.onCellTouch(cell, object: data[indexPath.row])
        }
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {}

    // MARK: - Private Methods

    private func setUpAdapter() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.prefetchDataSource = self
        notifyDataSetHasChanged()
    }

}


