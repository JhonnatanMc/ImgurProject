//
//  BaseViewController.swift
//  TravelTracker
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Abhisek. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, BaseView {

    private var spinnerView: SpinnerView!

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
        spinnerView = SpinnerView()
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(spinnerView)

        spinnerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        spinnerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 0).isActive = true
        spinnerView.showLoadingSpinner()
    }

    func hideLoadingSpinner() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
    }

}
