//
//  WebServiceManager.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
// requestAPI

import Alamofire
import Foundation

protocol WebServiceManagerProtocol: class {
    func getSearchResult(page: String, textSearch: String, callback: @escaping (Data?, String, Int) -> Void) -> Void
}

extension WebServiceManagerProtocol {

    func getSearchResult(page: String, textSearch: String, callback: @escaping (Data?, String, Int) -> Void) -> Void {
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        dataTask?.cancel()

        guard var urlComponents = URLComponents(string: BaseUrl.requestUrl(page: page)) else {
            return
        }

        urlComponents.query = "q=\(textSearch)"

        guard let url = urlComponents.url else {
            return
        }

        var request = URLRequest.init(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = BaseUrl.getHeaders()

        dataTask = defaultSession.dataTask(with: request, completionHandler: { (data, response, error) in
            defer { dataTask = nil }
            guard let response = response as? HTTPURLResponse else {
                return
            }

            if response.statusCode == BaseUrl.statusCode.success.rawValue {
                callback(data, "Success", 200)
            } else {
                guard let error = error else {
                    return
                }

                callback(nil, "DataTask error \(error.localizedDescription)", response.statusCode)
            }

        })
        dataTask?.resume()

    }

}

struct BaseUrl {
    struct Constants {
        static let cliendId = "Client-ID 126701cd8332f32"
        static let baseUrl = "https://api.imgur.com/3/gallery/search/time/"
        static let headers = ["Content-Type": "application/x-www-form-urlencoded", "Accept": "application/json", "Authorization": Constants.cliendId]
    }

    static func requestUrl(page: String) -> String {
        return Constants.baseUrl + page
    }

    static func getHeaders() -> [String: String] {
        return Constants.headers
    }

    enum statusCode: Int {
        case success = 200
    }

}
