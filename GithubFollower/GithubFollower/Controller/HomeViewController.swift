//
//  ViewController.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import UIKit

final class HomeViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var heartButton: UIButton!
    
    private let users = DatabaseGetter().getUsers()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.customizeView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction private func heartButtonTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: Identifier.favourite.rawValue) as? FavouriteViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserTableViewCell.self)
        cell.config(users[indexPath.row])
        cell.goDetail = {
            if let vc = self.storyboard?.instantiateViewController(identifier: Identifier.profile.rawValue) as? ProfileViewController {
                vc.userIndex = indexPath.row
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        return cell
    }
}

