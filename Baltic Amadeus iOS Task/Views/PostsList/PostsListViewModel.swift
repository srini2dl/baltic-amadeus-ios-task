//
//  PostsListViewModel.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation

class PostsListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var showingAlert = false
    var erroMessage: String = ""
    private let postRepository: PostRepository
    
    init(postRepository: PostRepository = .shared) {
        self.postRepository = postRepository
    }
    
    @MainActor
    func loadPosts() async {
        do {
            posts = try await postRepository.getPosts()
        } catch {
            handleError(error: error)
        }
    }
    
    @MainActor
    func refresh() async {
        do {
            posts = try await postRepository.fetchPosts()
        } catch {
            handleError(error: error)
        }
    }
    
    func handleError(error: Error) {
        if let error = error as? NetworkError {
            erroMessage = error.message
        } else {
            erroMessage = error.localizedDescription
        }
        showingAlert = true
    }
}
