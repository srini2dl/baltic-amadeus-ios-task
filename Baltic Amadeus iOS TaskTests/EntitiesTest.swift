//
//  Baltic_Amadeus_iOS_TaskTests.swift
//  Baltic Amadeus iOS TaskTests
//
//  Created by Srinivasan Raman on 2023-05-07.
//

import XCTest
import CoreData

@testable import Baltic_Amadeus_iOS_Task

final class EntitiesTest: XCTestCase {
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    func testPostEntityConversionToPost() throws {
        let postEntity = PostEntity(context: setUpInMemoryManagedObjectContext())
        postEntity.id = 1
        postEntity.title = "Test title"
        postEntity.body = "Test body"
        postEntity.userId = 1
        
        let post = Post(entity: postEntity)
        XCTAssertEqual(post?.id, 1)
        XCTAssertEqual(post?.title, "Test title")
        XCTAssertEqual(post?.body, "Test body")
        XCTAssertEqual(post?.userId, 1)
    }
    
    func testUserEntityConversionToUser() throws {
        let managedObjectContext = setUpInMemoryManagedObjectContext()
        let userEntity = UserEntity(context: managedObjectContext)
        userEntity.id = 123
        userEntity.name = "John Doe"
        userEntity.username = "johndoe"
        userEntity.email = "johndoe@example.com"
        userEntity.phone = "555-555-5555"
        userEntity.website = "www.johndoe.com"
        
        let addressEntity = AddressEntity(context: managedObjectContext)
        addressEntity.street = "123 Main St"
        addressEntity.suite = "Apt 1"
        addressEntity.city = "Anytown"
        addressEntity.zipcode = "12345"
        addressEntity.lat = "42.123"
        addressEntity.lng = "-73.123"
        
        let companyEntity = CompanyEntity(context: managedObjectContext)
        companyEntity.name = "Acme Inc"
        companyEntity.catchPhrase = "We make everything"
        companyEntity.bs = "Sales"
        
        
        userEntity.address = addressEntity
        userEntity.company = companyEntity
        
        do {
            try managedObjectContext.save()
        } catch {
            XCTFail("Failed to save context: \(error)")
        }
        
        let user = User(entity: userEntity)
        
        XCTAssertEqual(user?.id, 123)
        XCTAssertEqual(user?.name, "John Doe")
        XCTAssertEqual(user?.username, "johndoe")
        XCTAssertEqual(user?.email, "johndoe@example.com")
        XCTAssertEqual(user?.phone, "555-555-5555")
        XCTAssertEqual(user?.website, "www.johndoe.com")
        
        let address = user?.address
        XCTAssertEqual(address?.street, "123 Main St")
        XCTAssertEqual(address?.suite, "Apt 1")
        XCTAssertEqual(address?.city, "Anytown")
        XCTAssertEqual(address?.zipcode, "12345")
        XCTAssertEqual(address?.geo.lat, "42.123")
        XCTAssertEqual(address?.geo.lng, "-73.123")
        
    }
}
