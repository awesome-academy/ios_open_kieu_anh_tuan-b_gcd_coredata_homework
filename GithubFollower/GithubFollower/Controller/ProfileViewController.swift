//
//  ProfileViewController.swift
//  GithubFollower
//
//  Created by Tobi on 30/08/2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var userAvatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userAddressLabel: UILabel!
    @IBOutlet private weak var userJobPositionLabel: UILabel!
    @IBOutlet private weak var followersLabel: UILabel!
    @IBOutlet private weak var followingLabel: UILabel!
    @IBOutlet private weak var repositoryLabel: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var userTableView: UITableView!
    
    var userURL: String?
    private var userProfile: User?
    private var followers = [User]()
    private var following = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let userURL = userURL {
            getUserProfileData(userURL)
        }
        setUISegmentControlAppearance()
        userTableView.delegate = self
        userTableView.dataSource = self
    }
    
    private func setUISegmentControlAppearance() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .white
        UISegmentedControl.appearance().backgroundColor = .mainColor
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.mainColor], for: .selected)
    }
    
    private func configUser(_ user: User) {
        self.userAvatarImageView.applyCircleImage()
        self.userNameLabel.text = user.name
        self.userAddressLabel.text = user.location
        self.userJobPositionLabel.text = user.bio
        
        self.followersLabel.text = String(user.followers ?? 0)
        self.followingLabel.text = String(user.following ?? 0)
        self.repositoryLabel.text = String(user.publicRepos ?? 0)
        
        guard let url = URL(string: user.avatarUrl) else { return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async {
                    self?.userAvatarImageView.image = UIImage(data: data)
                }
            }
        }
        
        dataTask.resume()
    }
    
    private func getUserProfileData(_ userURL: String) {
        let userDetailQueue = DispatchQueue(label: "userDetailQueue", qos: .utility)
        
        DatabaseGetter.shared.getUserDetail(userURL: userURL) {
            result in
            userDetailQueue.async { [weak self] in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let usersData):
                    self.userProfile = usersData
                    if let userProfile = self.userProfile {
                        self.configUser(userProfile)
                        if let followersURL = userProfile.followersUrl {
                            self.getFollowers(followersURL)
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getFollowers(_ userURL: String) {
        let userFollowersQueue = DispatchQueue(label: "userFollowersQueue", qos: .utility)
        
        DatabaseGetter.shared.getFollowers(userURL: userURL) {
            result in
            userFollowersQueue.async { [weak self] in
                switch result {
                case .success(let followers):
                    self?.followers = followers
                    DispatchQueue.main.async { [weak self] in
                        self?.userTableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func heartButtonTapped(_ sender: Any) {
        guard let userProfile = userProfile else {
            return
        }
        
        let dataManager = DataPersistenceManager.shared
        
        if dataManager.checkEntityExists(url: userProfile.url) {
            self.showAlert(message: "Item already exist", controller: self)
        } else {
            dataManager.addToFavourite(userProfile) { result in
                switch result {
                case .success():
                    self.showAlert(message: "Added to favourite", controller: self)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        followers.count
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(UserTableViewCell.self)
        cell.config(followers[indexPath.row])
        
        return cell
    }
}
