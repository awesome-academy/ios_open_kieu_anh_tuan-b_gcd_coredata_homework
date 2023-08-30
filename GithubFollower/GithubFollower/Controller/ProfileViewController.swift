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
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var userTableView: UITableView!
    
    var userIndex = 0
    private let users = DatabaseGetter().getUsers()

    override func viewDidLoad() {
        super.viewDidLoad()

        configData(users[userIndex])
        
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
    
    private func configData(_ user: User) {
        self.userAvatarImageView.image = UIImage(named: user.avatar)
        self.userAvatarImageView.applyCircleImage()
        self.userNameLabel.text = user.name
        self.userAddressLabel.text = user.address
        self.userJobPositionLabel.text = user.jobPosition
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userTableView.dequeueReusableCell(UserTableViewCell.self)
        cell.config(users[indexPath.row])
        
        return cell
    }
}
