//
//  PostsListViewModel.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation

class PostsListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    private let apiService: BalticTaskService
    private let postRepository: PostRepository
    
    init(
        apiService: BalticTaskService = APIService.shared,
        postRepository: PostRepository = .shared
    ) {
        self.apiService = apiService
        self.postRepository = postRepository
    }
    
    @MainActor
    func loadPosts() async {
        do {
            let post = await postRepository.getPosts()
            if !post.isEmpty {
                self.posts = post
            } else {
                self.posts = try await apiService.fetchPost()
                postRepository.savePosts(posts)
            }
        } catch {
            //TODO: Handle error with a alertpopup
            print("\(error)")
        }
    }
}
