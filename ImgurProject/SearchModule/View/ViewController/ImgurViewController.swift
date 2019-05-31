//
//  ImgurViewController.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/21/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit
import Foundation

class ImgurViewController: BaseViewController, ImgurViewControllerProtocol {

    // MARK: - Constants

    struct Constants {
        static let patternImage = UIImage(named: "pattern")
        static let customBarTinColor = UIColor(red: 37.0/255.0, green: 59.0/255.0, blue: 86.0/255.0, alpha: 1.0)
        static let titleView = "Imgur"
        static let cancel = "Cancel"
        static let searchText = "Search your Image"
        static let fontSize = UIFont.systemFont(ofSize: 14)
        static let foregroundColor = UIColor.gray
        static let barButtonColor = UIColor.white
        static let collectionViewAccessibilityIdentifier = "collectionView"
    }

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    private var timer: Timer? = nil
    var collectionViewAdapter: ImgurCollectionViewAdapter?
    var presenter: ImgurPresenter?

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImgurFactory.makeImgurPresenter()
        setupCollectionView()
        setStylesforNavigationBar(Constants.titleView)
        setupView()
        presenter?.set(withView: self)
        setupSearchBar()
    }

    // MARK: Public Methods

    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.accessibilityIdentifier = Constants.collectionViewAccessibilityIdentifier
        guard let presenter = presenter else {
            return
        }

        collectionViewAdapter = ImgurCollectionViewAdapter(collectionView: collectionView, onCellTouchListener: presenter, prefetchListener: presenter)

        // why do you use upCasting instead use the specific type?
        // A: I setup it for Interfaz builder,  so I need get it again for set its delegate
        if let layout = collectionView?.collectionViewLayout as? ImageLayout {
            layout.delegate = collectionViewAdapter
        }
    }

    func setupView() {
        guard let patternImage = Constants.patternImage else {
            return
        }

        view.backgroundColor = UIColor(patternImage: patternImage)
    }

    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        searchBar.barTintColor = Constants.customBarTinColor

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = Constants.cancel
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue):  Constants.barButtonColor], for: .normal)

        let placeholderAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key.foregroundColor: Constants.foregroundColor, NSAttributedString.Key.font:  Constants.fontSize]
        let textFieldPlaceHolder = searchBar.value(forKey: "searchField") as? UITextField
        textFieldPlaceHolder?.attributedPlaceholder = NSAttributedString(string: Constants.searchText, attributes: placeholderAttributes)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let presenter = presenter else {
            return
        }

        presenter.dismissKeyboard()
    }

}

// MARK: - UISearchBarDelegate

extension ImgurViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar .resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        guard let presenter = presenter else {
            return
        }

        presenter.dismissKeyboard()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)

        guard let presenter = presenter else {
            return
        }

        presenter.cleanView()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let presenter = presenter else {
            return
        }

        presenter.dismissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let presenter = presenter else {
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
        presenter?.dismissKeyboard()
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
