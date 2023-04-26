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
    
    init(
        apiService: BalticTaskService = APIService.shared
    ) {
        self.apiService = apiService
    }
    
    @MainActor
    func loadPosts() async {
        do {
            //TODO: Create a CoreDBService and load to post
            posts = try await apiService.fetchPost()
        } catch {
            //TODO: Handle error with a alertpopup
            print("\(error)")
        }
    }
}
