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

    // MARK: - Constants

    struct K {
        static let maxPhotoHeight: CGFloat = 200
    }

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    private var timer: Timer? = nil
    private var collectionViewAdapter: ImgurCollectionViewAdapter?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImgurFactory.makeImgurPresenter()
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

        guard let presenter = (presenter as? ImgurPresenter) else {
            return
        }

        collectionViewAdapter = ImgurCollectionViewAdapter(collectionView: collectionView, onCellTouchListener: presenter, prefetchListener: presenter)

        if let layout = collectionView?.collectionViewLayout as? ImageLayout {
            layout.delegate = collectionViewAdapter
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

// MARK: - UISearchBarDelegate

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

// MARK: - ImgurView extension

extension ImgurViewController: ImgurView {

    func displaySpinner() {
        showLoadingSpinner()
    }

    func hideSpinner() {
        hideLoadingSpinner()
    }

    func cleanView() {
        collectionViewAdapter?.clear()
        collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        searchBar.text = ""
        (presenter as? ImgurPresenterProtocol)?.dismissKeyboard()
    }

    func showPhotos(photosArr: [Imgur]) {
        collectionViewAdapter?.addData(data: photosArr)
    }

    func getImageTitle() -> String? {
        return searchBar.text
    }

    func getViewController() -> UIViewController {
        return self
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}
