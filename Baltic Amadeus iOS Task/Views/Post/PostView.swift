//
//  PostView.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import SwiftUI

struct PostView: View {
    let post: Post
    @State var user: User?
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            Text(post.title).font(.title2)
            if let user {
                NavigationLink(destination: UserDetailView(user: user)) {
                    Text(user.name)
                }
            } else {
                ProgressView()
                    .onAppear {
                        Task {
                            self.user = try await UserRepository.shared.getUser(id: post.userId)       
                        }
                    }
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            PostView(post: Post.mock)
        }
    }
}
