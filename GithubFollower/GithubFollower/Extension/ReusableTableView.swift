//
//  ReusableTableView.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import UIKit

protocol ReusableTableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableTableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
