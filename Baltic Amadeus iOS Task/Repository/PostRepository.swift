//
//  PostRepository.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation

class PostRepository {
    let coreDataService: CoreDataService
    static let shared = PostRepository()
    private let apiService: BalticTaskAPIService
    private var cachedPosts: [Post] = []
    
    private init(
        coreDataService: CoreDataService = CoreDataService.shared,
        apiService: BalticTaskAPIService = APIService.shared
    ) {
        self.coreDataService = coreDataService
        self.apiService = apiService
        loadCache()
    }
    
    func loadCache() {
        cachedPosts = coreDataService.fetchPosts().compactMap({ Post(entity: $0) })
    }
    
    func getPosts() async throws -> [Post] {
        if !cachedPosts.isEmpty {
            return cachedPosts
        } else {
            return try await fetchPosts()
        }
    }
    
    func fetchPosts() async throws -> [Post] {
        cachedPosts = try await apiService.fetchPost()
        coreDataService.deletePost()
        return cachedPosts
    }
    
    func savePosts(_ posts: [Post]) {
        for post in posts {
            coreDataService.addPost(post)
        }
    }
}
