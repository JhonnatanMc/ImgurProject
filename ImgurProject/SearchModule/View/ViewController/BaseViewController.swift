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

    deinit {
        presenter?.unBind()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
