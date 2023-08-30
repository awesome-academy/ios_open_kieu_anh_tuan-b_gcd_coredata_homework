//
//  SearchBarExtension.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import UIKit

extension UISearchBar {
    func customizeView() {
        self.barTintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.backgroundImage = UIImage()
        self.searchTextField.backgroundColor = UIColor.white
        self.searchTextField.textColor = .black
        self.searchTextField.leftView?.tintColor = .black
        self.setImage(UIImage(systemName: "person.circle.fill"), for: .search, state: .normal)
        
    }
}
