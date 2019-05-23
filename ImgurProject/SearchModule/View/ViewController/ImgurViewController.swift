//
//  ImgurViewController.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/21/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit
import Foundation

class ImgurViewController: BaseViewController {

    struct K {
        static let lastCellsVisible = 10
    }

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    private var photos = [Imgur]()
    private var timer: Timer? = nil
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImgurPresenter(imgurInteractor: ImgurInteractor(), imgurRouteWireframe: ImgurRouteWireFrame())
        setupCollectionView()
        setStylesforNavigationBar("Imgur")
        setupSearchBar()
        setupView()

        guard let presenter = presenter as? ImgurPresenterProtocol else {
            return
        }

        presenter.bind(withView: self)
    }

    // MARK: Public Methods

    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self

        if let layout = collectionView?.collectionViewLayout as? ImageLayout {
            layout.delegate = self
        }
    }

    func setupView() {
        guard let patternImage = UIImage(named: "pattern") else {
            return
        }

        view.backgroundColor = UIColor(patternImage: patternImage)
    }

    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        searchBar.barTintColor = UIColor(red: 37.0/255.0, green: 59.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)

        let placeholderAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 14)]
        let textFieldPlaceHolder = searchBar.value(forKey: "searchField") as? UITextField
        textFieldPlaceHolder?.attributedPlaceholder = NSAttributedString(string: "Search your Image", attributes: placeholderAttributes)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        (presenter as? ImgurPresenterProtocol)?.dismissKeyboard()
    }

}

// MARK: - UICollectionViewDataSource

extension ImgurViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgurCollectionViewCell", for: indexPath)
            as? ImgurCollectionViewCell else {
                return UICollectionViewCell()
        }

        cell.configureCell(imgur: photos[indexPath.row])
        return cell
    }

}

extension ImgurViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (presenter as? ImgurPresenterProtocol)?.didSelectItem(image: photos[indexPath.row], view: self)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension ImgurViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if  indexPath.item > (photos.count - K.lastCellsVisible) {
                guard let text = searchBar.text, let presenter = (presenter as? ImgurPresenterProtocol) else {
                    return
                }

                let isValidText =  presenter.isValidName(with: text)

                guard !isValidText else {
                    return
                }

                presenter.searchPhotos(ImageName: text, isPrefetch: true)
                break
            }
        }
    }
}

// MARK: - ImageLayoutDelegate

extension ImgurViewController: ImageLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        guard let imageHeight = photos[indexPath.item].images?.first?.height else {
            return 200
        }

        return CGFloat(imageHeight)
    }

}

extension ImgurViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar .resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        (presenter as? ImgurPresenterProtocol)?.dismissKeyboard()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        (presenter as? ImgurPresenterProtocol)?.cleanView()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        (presenter as? ImgurPresenterProtocol)?.dismissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presenter = self.presenter as? ImgurPresenterProtocol else {
            return
        }

        let isValidText = presenter.isValidName(with: searchText)

        guard !isValidText else {
            presenter.cleanView()
            return
        }

        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissKeyboard), userInfo: searchBar, repeats: false)
        presenter.searchPhotos(ImageName: searchText, isPrefetch: false)
    }

}

extension ImgurViewController: ImgurView {

    func displaySpinner() {
        showLoadingSpinner()
    }

    func hideSpinner() {
        hideLoadingSpinner()
    }

    func cleanView() {
        photos.removeAll()
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.setContentOffset(CGPoint(x:0,y:0), animated: false)
        searchBar.text = ""
        (presenter as? ImgurPresenterProtocol)?.dismissKeyboard()
    }

    func showPhotos(photosArr: [Imgur]) {
        photos = photosArr
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}
