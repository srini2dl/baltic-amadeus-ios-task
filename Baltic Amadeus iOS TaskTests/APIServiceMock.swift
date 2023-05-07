//
//  APIServiceMock.swift
//  Baltic Amadeus iOS TaskTests
//
//  Created by Srinivasan Raman on 2023-05-07.
//

import XCTest
@testable import Baltic_Amadeus_iOS_Task

final class APIServiceMock: BalticTaskAPIService {
    var posts: [Post] = []
    var user: User = User.mock
    
    var shouldReturnError = false
    
    func fetchPost() async throws -> [Post] {
        if shouldReturnError {
            throw NetworkError.invalidResponse
        } else {
            return posts
        }
    }
    
    func fetchUser(id: Int) async throws -> User {
        if shouldReturnError {
            throw NetworkError.invalidResponse
        } else {
            return User.mock
        }
    }
}

