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
        NavigationView {
            VStack {
                List(viewModel.posts) { post in
                    LazyVStack(alignment: .leading) {
                        NavigationLink {
                            UserDetailView(userId: post.userId)
                        } label: {
                            PostView(post: post)
                        }
                    }
                }
            }
            .navigationTitle("Posts")
            .task {
                await viewModel.loadPosts()
            }
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        PostsListView()
    }
}
