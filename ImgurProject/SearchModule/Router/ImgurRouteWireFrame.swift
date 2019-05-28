//
//  ImgurRouteWireFrame.swift
//  ImgurProject
//
//  Created by Jhonnatan Macias De La Puente on 5/23/19.
//  Copyright © 2019 Jhonnatan Macias. All rights reserved.
//

import UIKit

class ImgurRouteWireFrame {

    func navigateToImageDetails(image: Imgur, from viewController: UIViewController) {
        let ImageDetailView = ImgurFactory.makeDetailViewController()
        ImageDetailView.image = image

        guard let sourceNavigationController = viewController.navigationController else {
            viewController.present(ImageDetailView, animated: true, completion: nil)
            return
        }

        sourceNavigationController.pushViewController(ImageDetailView, animated: true)
    }

}

extension ImgurRouteWireFrame: ImgurWireframeProtocol {

    func showImageDetails(image: Imgur, from viewController: UIViewController) {
        navigateToImageDetails(image: image, from: viewController)
    }

}
