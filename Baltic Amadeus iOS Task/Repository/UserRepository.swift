//
//  UserRepository.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation

class UserRepository {
    let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func getUsers() async throws -> [User] {
        coreDataService
            .fetchUsers()
            .compactMap {
                User(entity: $0)
            }
    }
    
    func saveUsers(_ user: User) {
        coreDataService.addUser(user)
    }
}



