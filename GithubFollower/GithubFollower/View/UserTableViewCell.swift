//
//  UserTableViewCell.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import UIKit

final class UserTableViewCell: UITableViewCell, ReusableTableView {
    static var defaultReuseIdentifier = "cell"
    var goDetail: (() -> Void)?
    
    @IBOutlet private weak var userButton: UIButton!
    @IBOutlet private weak var userAvatarImageView: UIImageView!
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userLinkLabel: UILabel!
    
    override func layoutSubviews() {
        customizeView()
    }
    
    private func customizeView() {
        userButton.addShadow()
        userButton.layer.cornerRadius = 20
        userAvatarImageView.applyCircleImage()
        userLinkLabel.underline()
        userLinkLabel.textColor = .systemYellow
    }
    
    func config(_ user: User) {
        userAvatarImageView.image = UIImage(named: user.avatar)
        userNameLabel.text = user.name
        userLinkLabel.text = user.url
    }
    
    @IBAction private func contentViewTapped(_ sender: Any) {
        goDetail?()
    }
}
