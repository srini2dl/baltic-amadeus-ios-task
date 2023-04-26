//
//  PostsListView.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import SwiftUI

struct PostsListView: View {
    @StateObject private var viewModel = PostsListViewModel()

    var body: some View {
        VStack {
            List(viewModel.posts) { post in
                LazyVStack {
                    Text(post.title)
                }
            }
        }
        .task {
            await viewModel.loadPosts()
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
