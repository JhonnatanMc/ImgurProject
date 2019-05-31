//
//  WebServiceManager.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
// requestAPI

import Alamofire
import Foundation


class RequestWithSessionDelegate: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let d = try? Data(contentsOf: location) {
            let im = UIImage(data:d)
            DispatchQueue.main.async {
                print(im)
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten writ: Int64,
                    totalBytesExpectedToWrite exp: Int64) {
        print("downloaded \(100*writ/exp)%")
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print("completed: error: \(error)")
    }

    lazy var session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.allowsCellularAccess = false
        let session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        return session
    }()

    func requestWithSessionDelegate() {
        let s = "https://images.pexels.com/photos/237018/pexels-photo-237018.jpeg"
        let url = URL(string: s)!
        let request = URLRequest(url: url)
        let task = self.session.downloadTask(with: request)
        task.resume()

//        let ob = task.progress.observe(\.fractionCompleted) { prog, change in
//            print("downloaded_ \(Int(100*prog.fractionCompleted))%")
//        }
}

}

protocol WebServiceManagerProtocol: class {
    func getSearchResult(page: String, textSearch: String, callback: @escaping (Data?, String, Int) -> Void) -> Void
}

extension WebServiceManagerProtocol {

    func downloadTask() {
        let s = "https://images.pexels.com/photos/237018/pexels-photo-237018.jpeg"
        let url = URL(string: s)!
        let session = URLSession.shared
        let task = session.downloadTask(with: url) { fileURL, resp, err in
            guard err == nil else {
                print(err.debugDescription)
                return
            }

            guard let response = (resp as? HTTPURLResponse), 200 == response.statusCode else {
                return
            }

            if let url = fileURL, let d = try? Data(contentsOf: url) {
                let im = UIImage(data: d)
                DispatchQueue.main.async {
                    print(im)
                }
            }
        }

        task.resume()
    }

    func dataTask() {
        let s = "https://images.pexels.com/photos/237018/pexels-photo-237018.jpeg"
        let url = URL(string: s)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, resp, err in
            guard err == nil else {
                print(err.debugDescription)
                return
            }

            guard let response = (resp as? HTTPURLResponse), 200 == response.statusCode else {
                return
            }

            if let imageData = data {
                let im = UIImage(data: imageData)
                DispatchQueue.main.async {
                    print(im)
                }
            }
        }
        print(task.progress)
        task.resume()
    }

    func getSearchResult(page: String, textSearch: String, callback: @escaping (Data?, String, Int) -> Void) -> Void {
        var dataTask: URLSessionDataTask?
        let defaultSession = URLSession(configuration: .default)
        dataTask?.cancel()

        guard var urlComponents = URLComponents(string: BaseUrl.requestUrl(page: page)) else {
            return
        }

        urlComponents.query = "q=\(textSearch)&q_type=jpg&q_size_px=300"

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
