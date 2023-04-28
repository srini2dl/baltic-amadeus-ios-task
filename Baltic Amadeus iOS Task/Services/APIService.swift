//
//  APIService.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation

protocol BalticTaskAPIService {
    func fetchPost() async throws -> [Post]
    func fetchUser(id: Int) async throws -> User
}

final class APIService: BalticTaskAPIService {
    static let shared = APIService()
    private let session = URLSession.shared
    private let baseURL = URL(string: "https://jsonplaceholder.typicode.com")
    
    enum EndPoint: String {
        case posts = "posts"
        case users = "users"
    }
    
    private init() {}
    
    func fetchUser(id: Int) async throws -> User {
        try await fetch(endPoint: "\(EndPoint.users.rawValue)/\(id)")
    }
    
    func fetchPost() async throws -> [Post] {
        try await fetch(endPoint: EndPoint.posts.rawValue)
    }
    
    private func fetch<T:Decodable>(endPoint: String) async throws -> T {
        guard let url = baseURL?.appendingPathComponent(endPoint)
        else {
            throw NetworkError.invalidUrl
        }
        let (data, response) = try await session.data(for: URLRequest(url: url))
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw NetworkError.invalidStatusCode(httpResponse.statusCode)
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case invalidStatusCode(Int)
    case decodingFailed
    
    var message: String {
        switch self {
        case .invalidUrl:
            return "Invalid url"
        case .invalidResponse:
            return "Invalid response"
        case .invalidStatusCode(let int):
            return "Something failed \(int)"
        case .decodingFailed:
            return "Unable to decode the response"
        }
    }
}
