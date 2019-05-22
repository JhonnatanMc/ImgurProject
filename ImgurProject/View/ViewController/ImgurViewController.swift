//
//  ImgurViewController.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/21/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

class ImgurViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    // MARK: - Properties

    internal var searchTitleImage: String = ""
    var photos = [Photo]()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        collectionView.dataSource = self
        collectionView.delegate = self

        if let layout = collectionView?.collectionViewLayout as? ImageLayout {
            layout.delegate = self
        }

        setupSearchBar()

        guard let patternImage = UIImage(named: "pattern") else {
            return
        }

        view.backgroundColor = UIColor(patternImage: patternImage)
    }

    // MARK: Public Methods

    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = .done

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white], for: .normal)

        let placeholderAttributes: [NSAttributedString.Key : AnyObject] = [NSAttributedString.Key.foregroundColor: UIColor.gray, NSAttributedString.Key.font:  UIFont.systemFont(ofSize: 14)]
        let textFieldPlaceHolder = searchBar.value(forKey: "searchField") as? UITextField
        textFieldPlaceHolder?.attributedPlaceholder = NSAttributedString(string: "Search your Image", attributes: placeholderAttributes)
    }

    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }

}

// MARK: - UICollectionViewDataSource

extension ImgurViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgurCollectionViewCell", for: indexPath as IndexPath) as! ImgurCollectionViewCell
        cell.photo = photos[indexPath.item]
        return cell
    }

}

extension ImgurViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let albumView = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
//        albumView.artistName = self.searchText
        self.navigationController?.pushViewController(albumView, animated: true)
    }
}

extension ImgurViewController: ImageLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return photos[indexPath.item].image.size.height
    }

}

extension ImgurViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar .resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.dismissKeyboard()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if !searchText.isEmpty {
            //            self.addSpinner()
            //            self.isSearchActived = true
            self.searchPhoto(searchText)
        } else {
           photos.removeAll()
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            //            self.isSearchActived = false
            self.dismissKeyboard()
        }
    }


    /// search an artist
    ///
    /// - Parameter searchText: the name of artist for looking
    func searchPhoto(_ searchText: String) {
        //        timer?.invalidate()
        //
        //        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.dismissKeyboard), userInfo: searchBar, repeats: false)
        self.searchTitleImage = searchText.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        guard !searchTitleImage.isEmpty else {
            return
        }
        let photoName = searchTitleImage.replacingOccurrences(of: " ", with: "%20")
        photos = Photo.allPhotos().filter({$0.caption.contains(photoName)})
        WebServiceManager.sharedService.requestAPI(textSearch: photoName, page: "1") {  (JSON: Data?, status: Int) in
            do {
                if status == 200 {
                    let myStructDictionary = try JSONDecoder().decode(Result.self, from: JSON!)

                    print(myStructDictionary)
                }
            } catch {
    //                callback(Array<Artist>(), true, "Unable to reach server. Please check Internet connectivity and try again later.", status)
            }
        }
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        //            ArtistController.getArtist(artistName: artistName) { (artists, error, errorMessage, status) in
        //                if !error {
        //                    self.artistFilteredArray = artists
        //                    self.artistCollectionView.reloadData()
        //                } else {
        //                    self.showAlert(errorMessage)
        //                }
        //            }

        //        self.removeSpinner()
    }

}

