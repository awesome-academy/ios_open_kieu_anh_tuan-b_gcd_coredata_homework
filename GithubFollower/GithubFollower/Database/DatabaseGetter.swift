//
//  DatabaseGetter.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import Foundation

class DatabaseGetter {
    func getUsers() -> [User] {
        return [
            User(
                avatar: "defaultAvatar",
                name: "User1",
                url: "www.github.com",
                address: "Tokyo",
                jobPosition: "Developer",
                followers: 200,
                following: 10,
                repository: 20
            ),
            User(
                avatar: "defaultAvatar",
                name: "User2",
                url: "www.github.com",
                address: "Tokyo",
                jobPosition: "Business Analy",
                followers: 32,
                following: 23,
                repository: 0
            ),
            User(
                avatar: "defaultAvatar",
                name: "User3",
                url: "www.github.com",
                address: "Tokyo",
                jobPosition: "Tester",
                followers: 32,
                following: 1023,
                repository: 2
            ),
        ]
    }
}
