//
//  Imgur.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

struct Imgur {

    var link: String?
    var title: String

    init() {
        link = ""
        title = ""
    }

    init(from decoder: Decoder) {
        self.init()

        do {
            let container = try decoder.container(keyedBy: ResultKeys.self)
            link = try container.decode(String.self, forKey: .link)
            title = try container.decode(String.self, forKey: .title)
        } catch let error {
            print("error parse Imgur result \(error)")
        }
    }

}

extension Imgur: Decodable {

    enum ResultKeys: String, CodingKey {
        case link = "link"
        case title = "title"
    }

}
