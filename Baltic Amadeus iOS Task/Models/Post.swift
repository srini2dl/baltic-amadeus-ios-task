//
//  Post.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation

struct Post: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
    let user: User?
    
    static let mock = Post(
        userId: 1,
        id: 1,
        title: "sunt aut ",
        body: "quia et suscipit\nsuscipit recusandae consequuntur "
    )
    
    init(
        userId: Int,
        id: Int,
        title: String,
        body: String,
        user: User? = nil
    ) {
        self.userId = userId
        self.id = id
        self.title = title
        self.body = body
        self.user = user
    }
    
    init?(entity: PostEntity) {
        guard let title = entity.title,
              let body = entity.body
        else {
            return nil
        }
        
        var user: User? {
            guard let userEntity = entity.user else { return nil }
            return User(entity: userEntity)
        }
        
        self.init(
            userId: Int(entity.userId),
            id: Int(entity.id),
            title: title,
            body: body,
            user: user
        )
    }
}
