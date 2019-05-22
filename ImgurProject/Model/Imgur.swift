//
//  Imgur.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

struct Imgur {

    var images: [Image]?
    var title: String?

    init() {
        images = [Image]()
        title = ""
    }

    init(from decoder: Decoder) {
        self.init()

        do {
            let container = try decoder.container(keyedBy: ResultKeys.self)
            title = try container.decodeIfPresent(String.self, forKey: .title)
            if let imagesArr = try container.decodeIfPresent([Image].self, forKey: .images) {
                images = imagesArr.filter { $0.link.contains(".jpg") }
            }
        } catch let error {
            print("error parse Imgur result \(error)")
        }
    }

}

extension Imgur: Decodable {

    enum ResultKeys: String, CodingKey {
        case images = "images"
        case title = "title"
    }

}
