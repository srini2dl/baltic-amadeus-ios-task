//
//  CoreDataService.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation
import CoreData

class CoreDataService {
    static let shared = CoreDataService()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataBaseModel")
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("BalticAmadeusDB.sqlite")
        container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private init() {}
    
    // MARK: - Saving
    
    func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                fatalError("Failed to save changes: \(error)")
            }
        }
    }
    
    // MARK: - Fetching
    
    func fetchUsers() -> [UserEntity] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            return try container.viewContext.fetch(request)
        } catch {
            fatalError("Failed to fetch users: \(error)")
        }
    }
    
    func fetchPosts() -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do {
            return try container.viewContext.fetch(request)
        } catch {
            fatalError("Failed to fetch posts: \(error)")
        }
    }
    
    // MARK: - Adding
    
    func addUser(_ user: User) {
        let entity = UserEntity(context: container.viewContext)
        entity.id = Int16(user.id)
        entity.name = user.name
        entity.username = user.username
        entity.email = user.email
        entity.phone = user.phone
        entity.website = user.website
        entity.address = AddressEntity(context: container.viewContext)
        entity.address?.street = user.address.street
        entity.address?.suite = user.address.suite
        entity.address?.city = user.address.city
        entity.address?.zipcode = user.address.zipcode
        entity.address?.lat = user.address.geo.lat
        entity.address?.lng = user.address.geo.lng
        entity.company = CompanyEntity(context: container.viewContext)
        entity.company?.name = user.company.name
        entity.company?.catchPhrase = user.company.catchPhrase
        entity.company?.bs = user.company.bs
        save()
    }
    
    func addPost(_ post: Post) {
        let entity = PostEntity(context: container.viewContext)
        entity.id = Int16(post.id)
        entity.title = post.title
        entity.body = post.body
//        entity.user = user
        save()
    }
}
