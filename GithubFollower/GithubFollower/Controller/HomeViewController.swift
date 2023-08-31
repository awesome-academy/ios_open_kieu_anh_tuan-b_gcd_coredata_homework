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
    
    private var users = [User]()
    private var searchResult = [User]()
    private var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        getUsers()
        searchBar.customizeView()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func getUsers() {
        let userQueue = DispatchQueue(label: "userQueue", qos: .utility)
        
        userQueue.async { [weak self] in
            DatabaseGetter.shared.getUsersFromAPI() {
                result in
                switch result {
                case .success(let usersData):
                    self?.users = usersData
                    DispatchQueue.main.async { [weak self] in
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction private func heartButtonTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: Identifier.favourite.rawValue) as? FavouriteViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return searchResult.count
        }
        return users.count
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UserTableViewCell.self)
        
        let userData = isSearching ? searchResult[indexPath.row] : users[indexPath.row]
        
        cell.config(userData)
        cell.goDetail = {
            if let vc = self.storyboard?.instantiateViewController(identifier: Identifier.profile.rawValue) as? ProfileViewController {
                vc.userURL = userData.url
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        return cell
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchResult = users.filter( {$0.login.prefix(searchText.count) == searchText} )
        isSearching = true
        tableView.reloadData()
    }
}

