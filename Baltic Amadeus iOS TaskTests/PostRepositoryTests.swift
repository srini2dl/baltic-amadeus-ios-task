//
//  PostsListViewModelTests.swift
//  Baltic Amadeus iOS TaskTests
//
//  Created by Srinivasan Raman on 2023-05-07.
//

import XCTest
@testable import Baltic_Amadeus_iOS_Task

final class PostRepositoryTests: XCTestCase {
    
    var postRepository: PostRepository!
    var coreDataServiceMock: CoreDataServiceMock!
    var apiService: APIServiceMock!
    
    override func setUp() {
        super.setUp()
        coreDataServiceMock = CoreDataServiceMock()
        apiService = APIServiceMock()
        postRepository = PostRepository(
            coreDataService: coreDataServiceMock,
            apiService: apiService
        )
    }
    
    func testFetchPostsFailure() {
        let expectation = XCTestExpectation(description: "Invalid url")
        apiService.shouldReturnError = true
        Task {
            do {
                _ = try await postRepository.getPosts()
            } catch {
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 0.1)
    }
    
    func testFetchPostsSuccess() {
        let expectation = XCTestExpectation(description: "Has a post")
        apiService.shouldReturnError = false
        apiService.posts = [Post.mock]
        let postCount = coreDataServiceMock
            .fetchPosts()
            .count
        XCTAssertEqual(postCount, 0)
        
        Task {
            do {
                _ = try await postRepository.getPosts()
                let posts = coreDataServiceMock
                    .fetchPosts()
                    .compactMap { Post(entity: $0) }
                XCTAssertEqual(posts.count, 1)
                XCTAssertEqual(posts.first?.id, Post.mock.id)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
}
