//
//  User.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import Foundation

struct UserResponse: Codable {
    var items: [User]
}

struct User: Codable {
    var login: String
    var avatarUrl: String
    var url: String
    var htmlUrl: String
    var name: String?
    var followersUrl: String?
    var followingUrl: String?
    var location: String?
    var bio: String?
    var followers: Int?
    var following: Int?
    var publicRepos: Int?
}
