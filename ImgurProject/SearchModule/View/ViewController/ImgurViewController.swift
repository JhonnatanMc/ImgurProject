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

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    internal var searchTitleImage: String = ""
    var photos = [Imgur]()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImgurPresenter()
        setupCollectionView()
        setStylesforNavigationBar("Imgur")
        setupSearchBar()
        setupView()

        guard let presenter = presenter as? ImgurPresenterProtocol else {
            return
        }

        presenter.bind(withView: self)
    }

    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
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

    // MARK: Public Methods

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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let albumView = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        self.navigationController?.pushViewController(albumView, animated: true)
    }
}

// MARK: - UICollectionViewDataSourcePrefetching

extension ImgurViewController: UICollectionViewDataSourcePrefetching {

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if  indexPath.item > (photos.count  - 5) {
                WebServiceManager.sharedService.requestAPI(textSearch: "cats", page: "2") {  (JSON: Data?, status: Int) in
                    do {
                        if status == 200 {
                            let myStructDictionary = try JSONDecoder().decode(Result.self, from: JSON!)
                            self.photos.append(contentsOf : myStructDictionary.data)
                            self.collectionView.reloadData()
                            self.collectionView.collectionViewLayout.invalidateLayout()
                        }
                    } catch {
                        //                callback(Array<Artist>(), true, "Unable to reach server. Please check Internet connectivity and try again later.", status)
                    }
                }
            }
        }
    }



}

// MARK: - ImageLayoutDelegate

extension ImgurViewController: ImageLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        guard let imageHeight = photos[indexPath.item].images?.first?.height else {
            return 300
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

        presenter.isValidName(with: searchText)
    }

    func searchPhoto(_ searchText: String) {
        //        timer?.invalidate()
        //
        //        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissKeyboard), userInfo: searchBar, repeats: false)
        self.searchTitleImage = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        guard !searchTitleImage.isEmpty else {
            return
        }

        let photoName = searchTitleImage.replacingOccurrences(of: " ", with: "%20")
        WebServiceManager.sharedService.requestAPI(textSearch: photoName, page: "1") {  (JSON: Data?, status: Int) in
            do {
                if status == 200 {
                    let myStructDictionary = try JSONDecoder().decode(Result.self, from: JSON!)
                    self.photos = myStructDictionary.data
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                }
            } catch {
                //                callback(Array<Artist>(), true, "Unable to reach server. Please check Internet connectivity and try again later.", status)
            }
        }

    }

}

extension ImgurViewController: ImgurView {

    func cleanView() {
        photos.removeAll()
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
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
