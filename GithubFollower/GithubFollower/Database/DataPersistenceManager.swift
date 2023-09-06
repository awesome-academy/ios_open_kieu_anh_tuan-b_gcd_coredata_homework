//
//  DataPersistanceManager.swift
//  GithubFollower
//
//  Created by Tobi on 05/09/2023.
//

import Foundation
import UIKit
import CoreData

final class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    static let shared = DataPersistenceManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GithubFollowerModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func addToFavourite(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = persistentContainer.viewContext
        let item = UserItem(context: context)
        
        item.login = user.login
        item.avatarUrl = user.avatarUrl
        item.url = user.url
        item.htmlUrl = user.htmlUrl
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func fetchingUsersFromDatabase(completion: @escaping (Result<[UserItem], Error>) -> Void) {
        let context = persistentContainer.viewContext
        
        let request: NSFetchRequest<UserItem>
        
        request = UserItem.fetchRequest()
        
        do {
            let users = try context.fetch(request)
            completion(.success(users))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteUser(_ user: UserItem, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = persistentContainer.viewContext
        
        context.delete(user)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
    
    func checkEntityExists(url: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserItem")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "url == %@" ,url)
        var entitiesCount = 0
        
        do {
            let context = persistentContainer.viewContext
            entitiesCount = try context.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }

        return entitiesCount > 0
    }
}
