//
//  WebServiceManager.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
// requestAPI

import Alamofire
import Foundation

class WebServiceManager {

    struct K {
        static let cliendId = "Client-ID 126701cd8332f32"
        static let baseUrl = "https://api.imgur.com/3/gallery/search/time/"
    }

    static let sharedService = WebServiceManager()
    typealias WebServiceCompletionBlock = (Data?, Int) -> Void

    func requestAPI(textSearch : String, page: String, successCallback : @escaping WebServiceCompletionBlock) -> Void {
        let headers = ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization": K.cliendId]

        Alamofire.request(K.baseUrl + page + "?q=\(textSearch)", method: .get, encoding: URLEncoding.default, headers: headers).validate().responseJSON { response in
            if response.response?.statusCode == nil {
                successCallback(nil, 0)
            } else if response.response?.statusCode == 200 && response.data != nil {
                successCallback(response.data!, 200)
            }
        }
    }
}
