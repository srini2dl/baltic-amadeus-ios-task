//
//  CoreDataService.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation
import CoreData

protocol CoreDataServicing {
    func fetchPosts() -> [PostEntity]
    func fetchUsers() -> [UserEntity]
    func fetchUser(by userId: Int) -> UserEntity?
    func addUser(_ user: User)
    func addPosts(_ posts: [Post])
    func deletePostsAndUsers()
}

class CoreDataService: CoreDataServicing {
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
    
    lazy var mainContext: NSManagedObjectContext = {
        let context = container.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    private init() {}
    
    // MARK: - Saving
    
    private func save() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                fatalError("Failed to save changes: \(error)")
            }
        }
    }
    
    // MARK: - Fetching
    
    func fetchUser(by userId: Int) -> UserEntity? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", String(userId))
        do {
            let result = try mainContext.fetch(request)
            return result.first
        }
        catch {
           fatalError("Failed to fetch user: \(error)")
       }
    }
    
    func fetchUserPosts(by userId: Int) -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "userId == %@", String(userId))
        do {
            let result = try mainContext.fetch(request)
            return result
        }
        catch {
           fatalError("Failed to fetch user: \(error)")
       }
    }
    
    func fetchUsers() -> [UserEntity] {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        do {
            return try mainContext.fetch(request)
        } catch {
            fatalError("Failed to fetch users: \(error)")
        }
    }
    
    func fetchPosts() -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        do {
            return try mainContext.fetch(request)
        } catch {
            fatalError("Failed to fetch posts: \(error)")
        }
    }
    
    
    // MARK: - Adding
    
    let serialQueue = DispatchQueue(label: "com.app.baltictask")
    func addUser(_ user: User) {
        serialQueue.sync {
            guard fetchUser(by: user.id) == nil else { return }
            let posts = fetchUserPosts(by: user.id)
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
            entity.posts = NSSet(array: posts)
            save()
        }
    }
    
    func addPosts(_ posts: [Post]) {
        container.performBackgroundTask { context in
            let dictionaries = posts.map { post -> [String: Any] in
                return [
                    "id": Int16(post.id),
                    "title": post.title,
                    "body": post.body,
                    "userId": Int16(post.userId)
                ]
            }
            
            let array = NSMutableArray()
            for dict in dictionaries {
                let nsDict = NSMutableDictionary(dictionary: dict)
                array.add(nsDict)
            }
            
            let batchInsert = NSBatchInsertRequest(entity: PostEntity.entity(), objects: array as! [[String : Any]])
            
            do {
                try context.execute(batchInsert)
            } catch {
                print("Error inserting posts: \(error.localizedDescription)")
            }
        }
    }

    
    func deletePostsAndUsers() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: PostEntity.fetchRequest())
        batchDeleteRequest.resultType = .resultTypeStatusOnly
        _ = try? mainContext.execute(batchDeleteRequest)
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: UserEntity.fetchRequest())
        _ = try? mainContext.execute(batchDeleteRequest2)
        batchDeleteRequest2.resultType = .resultTypeStatusOnly
        mainContext.reset()
    }
}
