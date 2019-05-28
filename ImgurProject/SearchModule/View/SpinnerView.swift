//
//  SpinnerView.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/28/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

class SpinnerView: UIView {

    private var spinner: UIActivityIndicatorView!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func showLoadingSpinner() {
        spinner?.removeFromSuperview()

        spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor.white
        spinner.startAnimating()
        addSubview(spinner)


        spinner.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
        spinner.widthAnchor.constraint(equalToConstant: 200).isActive = true
        spinner.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }

    func hideLoadingSpinner() {
        spinner?.stopAnimating()
        spinner?.removeFromSuperview()
        spinner = nil
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
