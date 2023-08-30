//
//  ImageViewExtension.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import UIKit

extension UIImageView {
    func applyCircleImage() {
        layer.cornerRadius = self.frame.width / 2
        self.layer.masksToBounds = true
    }
}
