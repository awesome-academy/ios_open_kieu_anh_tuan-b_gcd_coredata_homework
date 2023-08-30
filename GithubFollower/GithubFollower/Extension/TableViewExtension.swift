//
//  CustomTableView.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type) -> T where T: ReusableTableView {
        guard let cell =  self.dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.defaultReuseIdentifier)")
        }
        return cell
    }
}
