//
//  BaseViewController.swift
//  TravelTracker
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Abhisek. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, BaseView {

    var presenter: BasePresenterProtocol?
    private var spinner: UIActivityIndicatorView!
    private var spinnerView: UIView!

     var spinnerCount : Int = 0 {
        didSet {
            if spinnerCount > 0 {
                showLoadingSpinner()
            } else {
                hideLoadingSpinner()
            }
        }
    }

    deinit {
        presenter?.unBind()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setStylesforNavigationBar(_ title: String){
        navigationItem.title = title

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.barTintColor = UIColor(red: 37.0/255.0, green: 59.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    }

    func showLoadingSpinner() {
        spinnerView?.removeFromSuperview()
        spinner?.removeFromSuperview()

        spinnerView = UIView()
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.white
        spinner.startAnimating()
        view.addSubview(spinnerView)
        spinnerView?.addSubview(spinner)

        spinnerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        spinnerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        spinner.centerXAnchor.constraint(equalTo: spinnerView.centerXAnchor, constant: 0).isActive = true
        spinner.centerYAnchor.constraint(equalTo: spinnerView.centerYAnchor, constant: 0).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 200).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func hideLoadingSpinner() {
        spinner?.stopAnimating()
        spinnerView?.removeFromSuperview()
        spinner?.removeFromSuperview()
        spinnerView = nil
        spinner = nil
    }

    internal func addSpinner(){
        spinnerCount += 1
    }

    internal func removeSpinner(){
        spinnerCount -= 1
        if spinnerCount < 0{
            spinnerCount = 0
        }
    }

}
