//
//  UserButtonExtension.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import UIKit

extension UIButton {
    func addShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 5
    }
}
