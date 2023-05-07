//
//  UserRepositoryTests.swift
//  Baltic Amadeus iOS TaskTests
//
//  Created by Srinivasan Raman on 2023-05-07.
//

import XCTest
@testable import Baltic_Amadeus_iOS_Task

final class UserRepositoryTests: XCTestCase {
    
    var userRepository: UserRepository!
    var coreDataServiceMock: CoreDataServiceMock!
    var apiService: APIServiceMock!
    
    override func setUp() {
        super.setUp()
        coreDataServiceMock = CoreDataServiceMock()
        apiService = APIServiceMock()
        userRepository = UserRepository(
            coreDataService: coreDataServiceMock,
            apiService: apiService
        )
    }
    
    func testFetchUserFailure() {
        let expectation = XCTestExpectation(description: "Invalid url")
        apiService.shouldReturnError = true
        Task {
            do {
                _ = try await apiService.fetchUser(id: 1)
            } catch {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testFetchUserSuccess() {
        let expectation = XCTestExpectation(description: "Has a user")
        apiService.shouldReturnError = false
        let usersCount = coreDataServiceMock
            .fetchUsers()
            .count
        XCTAssertEqual(usersCount, 0)
        Task {
            do {
                _ = try await userRepository.getUser(id: User.mock.id)
                let users = coreDataServiceMock
                    .fetchUsers()
                    .compactMap { User(entity: $0) }
                XCTAssertEqual(users.count, 1)
                XCTAssertEqual(users.first?.id, User.mock.id)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
}
