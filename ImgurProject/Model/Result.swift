//
//  Data.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

struct Result {
    var data: [Imgur]

    init() {
        data = [Imgur]()
    }

    init(from decoder: Decoder) {
        self.init()

        do {
            let container = try decoder.container(keyedBy: ResultKeys.self)
            if let dataResult = try container.decodeIfPresent([Imgur].self, forKey: .data) {
                data = dataResult.filter { $0.images!.count > 0 }
            }
        } catch let error {
            print("error parse result result \(error)")
        }
    }

}

extension Result: Decodable {

    enum ResultKeys: String, CodingKey {
        case data = "data"
    }

}
