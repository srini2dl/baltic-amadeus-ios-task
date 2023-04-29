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
    @State var error: NetworkError?

    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            Text(post.title).font(.title2)
            if let user {
                NavigationLink(destination: UserDetailView(user: user)) {
                    HStack {
                        Image(systemName: "person.circle.fill")
                        Text(user.name)
                    }
                }
            } else {
                if let error {
                    ErrorView(error: error) {
                        fetchUser()
                    }
                }
                ProgressView()
                    .onAppear { fetchUser() }
            }
        }
    }
    
    func fetchUser() {
            Task {
                do {
                    self.user = try await UserRepository.shared.getUser(id: post.userId)
                } catch {
                    if let error = error as? NetworkError {
                        self.error = error
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

struct ErrorView: View {
    let error: NetworkError
    let retryAction: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.badge.exclamationmark.fill")
            Button {
                retryAction()
            } label: {
                Text("Retry")
            }
        }
    }
}
