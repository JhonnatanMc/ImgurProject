//
//  BasePresenterProtocol.swift
//  TravelTracker
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Abhisek. All rights reserved.
//

import Foundation

protocol BaseView: class {}

protocol BasePresenterProtocol {

    var view: BaseView? { get set }

    func set(withView view: BaseView)

    func unSet()

}

class BasePresenter: NSObject, BasePresenterProtocol {

    weak var view: BaseView?

    func set(withView view: BaseView) {
        self.view = view
    }

    func unSet() {
        self.view = nil
    }

}
