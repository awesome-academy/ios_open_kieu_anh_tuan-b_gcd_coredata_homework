//
//  FavouriteViewController.swift
//  GithubFollower
//
//  Created by Tobi on 30/08/2023.
//

import UIKit

final class FavouriteViewController: UIViewController {
    
    @IBOutlet private weak var userTableView: UITableView!
    
    private var users = [UserItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLocalStorageForFavourite()
        
        userTableView.delegate = self
        userTableView.dataSource = self
    }
    
    private func fetchLocalStorageForFavourite(){
        DataPersistenceManager.shared.fetchingUsersFromDatabase { [weak self] result in
            switch result {
            case .success(let users):
                self?.users = users
                self?.userTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            DataPersistenceManager.shared.deleteUser(users[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    self?.showAlert(message: "Added to favourite", controller: self)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.users.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break
        }
    }
    
}

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(UserTableViewCell.self)
        let user = users[indexPath.row]
        cell.config(
            User(
                login: user.login ?? "",
                avatarUrl: user.avatarUrl ?? "",
                url: user.url ?? "",
                htmlUrl: user.htmlUrl ?? ""
            )
        )
        
        return cell
    }
}
