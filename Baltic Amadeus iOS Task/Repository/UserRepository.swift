//
//  UserRepository.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation

class UserRepository {
    let coreDataService: CoreDataServicing
    let apiService: BalticTaskAPIService
    static let shared = UserRepository()
    private var cachedUsers: [User] = []
    
    private init(
        coreDataService: CoreDataServicing = CoreDataService.shared,
        apiService: BalticTaskAPIService = APIService.shared
    ) {
        self.coreDataService = coreDataService
        self.apiService = apiService
        loadCache()
    }
    
    func loadCache() {
        cachedUsers = coreDataService.fetchUsers().compactMap { User(entity: $0) }
    }
    
    func getUser(id: Int) async throws -> User {
        if let user = cachedUsers.first(where: { $0.id == id }) {
            return user
        }
        guard let entity = coreDataService.fetchUser(by: id),
              let user = User(entity: entity)
        else {
            return try await fetchUser(id: id)
        }
        cachedUsers.append(user)
        return user
    }
    
    private func fetchUser(id: Int) async throws -> User {
        let user = try await apiService.fetchUser(id: id)
        cachedUsers.append(user)
        saveUsers(user)
        return user
    }
    
    private func saveUsers(_ user: User) {
        coreDataService.addUser(user)
    }
}
