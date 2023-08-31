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
    }
    
    func config(_ user: User) {
        userNameLabel.text = user.login
        userLinkLabel.text = user.htmlUrl
        
        guard let url = URL(string: user.avatarUrl) else { return }
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, _, _) in
            if let data = data {
                DispatchQueue.main.async { [weak self] in
                    self?.userAvatarImageView.image = UIImage(data: data)
                }
            }
        }
        dataTask.resume()
        setClickableLink()
    }
    
    private func setClickableLink() {
        userLinkLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(openLink))
        userLinkLabel.addGestureRecognizer(tap)
        userLinkLabel.underline()
        userLinkLabel.textColor = .systemOrange
    }
    
    @objc private func openLink() {
        if let openLink = URL(string: userLinkLabel.text ?? "https://github.com/") {
            if UIApplication.shared.canOpenURL(openLink) {
                UIApplication.shared.open(openLink, options: [:])
            }
        }
    }
    
    @IBAction private func contentViewTapped(_ sender: Any) {
        goDetail?()
    }
}
