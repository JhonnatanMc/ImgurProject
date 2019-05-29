//
//  BaseViewController.swift
//  TravelTracker
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Abhisek. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, BaseView {

    // MARK: - Constants

    struct Constants {
        static let navigationBarColor = UIColor.white
        static let barTinColor = UIColor(red: 37.0/255.0, green: 59.0/255.0, blue: 86.0/255.0, alpha: 1.0)
    }

    // MARK: - Properties

    private var spinnerView: SpinnerView!

     // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()
        addSpinner()
    }

    // MARK: - Public Methods

    func addSpinner() {
        spinnerView?.removeFromSuperview()
        spinnerView = SpinnerView()
        spinnerView.isHidden = true
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(spinnerView)

        spinnerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        spinnerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
    }

    func setStylesforNavigationBar(_ title: String){
        navigationItem.title = title

        navigationController?.navigationBar.tintColor = Constants.navigationBarColor
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Constants.navigationBarColor]
        navigationController?.navigationBar.barTintColor = Constants.barTinColor
    }

    func showLoadingSpinner() {
        spinnerView?.isHidden = false
        spinnerView?.showLoadingSpinner()
    }

    func hideLoadingSpinner() {
        spinnerView?.isHidden = true
        spinnerView?.hideLoadingSpinner()
    }

}
