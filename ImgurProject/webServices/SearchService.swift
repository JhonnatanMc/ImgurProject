//
//  SearchService.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

class SearchService {

    static let sharedService = SearchService()
    typealias WebServiceCompletionBlock = (Array<Imgur>, Bool, String, Int)->Void

    func search(textSearch: String, page: Int,  callback: @escaping WebServiceCompletionBlock) -> Void {
        let currentPage = String(page)

        WebServiceManager.sharedService.requestAPI(textSearch: textSearch, page: currentPage) { (JSON: Data?, status) in
            do {
                guard status == 200, let json = JSON else {
                    callback(Array<Imgur>(), true, "Error try get image information", status)
                    return
                }

                let imageDictionary =  try JSONDecoder().decode(Result.self, from: json)
                callback(imageDictionary.data, false, "success", status)
            } catch {
                callback(Array<Imgur>(), true, "Unable to reach server. Please check Internet connectivity and try again later.", status)
            }
        }
    }

}
