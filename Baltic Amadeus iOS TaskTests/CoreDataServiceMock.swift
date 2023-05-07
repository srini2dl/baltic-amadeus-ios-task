//
//  CoreDataServiceMock.swift
//  Baltic Amadeus iOS TaskTests
//
//  Created by Srinivasan Raman on 2023-05-07.
//

import XCTest
import CoreData
@testable import Baltic_Amadeus_iOS_Task

final class CoreDataServiceMock: CoreDataServicing {
    var posts: [PostEntity] = []
    var users: [UserEntity] = []
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    func fetchPosts() -> [PostEntity] {
        return posts
    }
    
    func fetchUsers() -> [UserEntity] {
        return users
    }
    
    func fetchUser(by userId: Int) -> UserEntity? {
        return users.first(where: { $0.id == userId })
    }
    
    func addUser(_ user: User) {
        let context = setUpInMemoryManagedObjectContext()
        let entity = UserEntity(context: context)
        entity.id = Int16(user.id)
        entity.name = user.name
        entity.username = user.username
        entity.email = user.email
        entity.phone = user.phone
        entity.website = user.website
        entity.address = AddressEntity(context: context)
        entity.address?.street = user.address.street
        entity.address?.suite = user.address.suite
        entity.address?.city = user.address.city
        entity.address?.zipcode = user.address.zipcode
        entity.address?.lat = user.address.geo.lat
        entity.address?.lng = user.address.geo.lng
        entity.company = CompanyEntity(context: context)
        entity.company?.name = user.company.name
        entity.company?.catchPhrase = user.company.catchPhrase
        entity.company?.bs = user.company.bs
        users.append(entity)
    }
    
    func addPosts(_ posts: [Post]) {
        for post in posts {
            let entity = PostEntity(context: setUpInMemoryManagedObjectContext())
            entity.id = Int16(post.id)
            entity.title = post.title
            entity.body = post.body
            entity.userId = Int16(post.userId)
            self.posts.append(entity)
        }
    }
    
    func deletePostsAndUsers() {
        posts.removeAll()
        users.removeAll()
    }
}
