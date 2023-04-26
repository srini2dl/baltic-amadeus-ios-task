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
    
    private init(coreDataService: CoreDataService = CoreDataService.shared) {
        self.coreDataService = coreDataService
    }
    
    func getPosts() async -> [Post] {
        coreDataService.fetchPosts().compactMap { Post(entity: $0) }
    }
    
    func savePosts(_ posts: [Post]) {
        for post in posts {
            coreDataService.addPost(post)
        }
    }
}
