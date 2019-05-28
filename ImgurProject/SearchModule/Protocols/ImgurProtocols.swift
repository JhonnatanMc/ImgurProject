//
//  ImgurProtocols.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

protocol SearchInteractorResultProtocol {
    //Interactor -> Presenter
    func didFinishFetchingRecentSearchResults(allSearches: [Imgur]?)
    func didFinishFetchingWithError()
}

protocol SearchInteractorProtocol {
    //Presenter -> Interactor
    var presenter: ImgurPresenter? { get set }
}

protocol onCellTouchListener: class {
    func onCellTouch<Cell: UICollectionViewCell>(_ cell: Cell, object: Any)
}

protocol CollectionViewPrefetchListener: class {
    func prefetchData()
}

protocol ImgurWireframeProtocol {
    //Presenter -> Wireframe
    func showImageDetails(image: Imgur, from viewController: UIViewController)
}

protocol ImgurViewControllerProtocol: class {
    var presenter: ImgurPresenter? { set get }
}

protocol ImageDetailViewControllerProtocol: class {
    var presenter: ImageDetailPresenter? { set get }
}
