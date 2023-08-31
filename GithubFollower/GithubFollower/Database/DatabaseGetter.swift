//
//  DatabaseGetter.swift
//  GithubFollower
//
//  Created by Tobi on 29/08/2023.
//

import Foundation

enum  APIError: Error {
    case failedToGetData
}

final class DatabaseGetter {
    static let shared = DatabaseGetter()
    
    func getUsersFromAPI(completion: @escaping (Result<[User], Error>) -> Void) {
        
        guard let url = URL(string: Endpoint.baseURL.rawValue) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else {
                return
            }
                        
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try jsonDecoder.decode(UserResponse.self, from: data)
                completion(.success(results.items))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func getUserDetail(userURL: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        guard let url = URL(string: userURL) else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else {
                return
            }
                        
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try jsonDecoder.decode(User.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
    
    func getFollowers(userURL: String, completion: @escaping (Result<[User], Error>) -> Void) {
        
        guard let url = URL(string: userURL) else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) {
            data, _, error in
            guard let data = data, error == nil else {
                return
            }
                                    
            do {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                let results = try jsonDecoder.decode([User].self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        task.resume()
    }
}
