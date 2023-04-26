//
//  PostView.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import SwiftUI

struct PostView: View {
    let post: Post
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            Text(post.title).font(.title2)
            //TODO: Instead of userID need to display username
            Text("\(post.userId)").font(.subheadline)            
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
