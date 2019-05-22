//
//  Image.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/22/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import Foundation

struct Image {

    var link: String
    var imageDescription: String?
    var title: String?
    var height: Int?

    init() {
        link = ""
        imageDescription = ""
        title = ""
        height = 0
    }

    init(from decoder: Decoder) {
        self.init()

        do {
            let container = try decoder.container(keyedBy:  ResultKeys.self)
            link =  try container.decode(String.self, forKey: .link)
            imageDescription = try container.decodeIfPresent(String.self, forKey: .imageDescription)
            title = try container.decodeIfPresent(String.self, forKey: .title)

            if let heightImage = try container.decodeIfPresent(Int.self, forKey: .height) {
                height = heightImage > 450 ? 450 : heightImage
            }

        } catch let error {
            print("error parse Image result \(error)")
        }
    }

}

extension Image: Decodable {

    enum ResultKeys: String, CodingKey {
        case link = "link"
        case imageDescription = "description"
        case title = "title"
        case height = "height"
    }

}




