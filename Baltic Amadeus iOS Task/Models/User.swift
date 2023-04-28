//
//  User.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
    
    init(
        id: Int,
        name: String,
        username: String,
        email: String,
        address: Address,
        phone: String,
        website: String,
        company: Company
    ) {
        self.id = id
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
    
    init?(entity: UserEntity) {
        guard let name = entity.name,
              let username = entity.username,
              let email = entity.email,
              let addressEntity = entity.address,
              let address = Address(entity: addressEntity),
              let phone = entity.phone,
              let website = entity.website,
              let companyEntity = entity.company,
              let company = Company(entity: companyEntity)
        else {
            assertionFailure("[Error] Invalid entity")
            return nil
        }
        
        self.id = Int(entity.id)
        self.name = name
        self.username = username
        self.email = email
        self.address = address
        self.phone = phone
        self.website = website
        self.company = company
    }
    
    static let mock = User(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        address: Address(
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874",
            geo: Geo(lat: "-37.3159", lng: "81.1496")
        ),
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        company: Company(
            name: "Romaguera-Crona",
            catchPhrase: "Multi-layered client-server neural-net",
            bs: "harness real-time e-markets"
        )
    )
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
    
    init(
        street: String,
        suite: String,
        city: String,
        zipcode: String,
        geo: Geo
    ) {
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = geo
    }
    
    init?(entity: AddressEntity) {
        guard let street = entity.street,
              let suite = entity.suite,
              let city = entity.city,
              let zipcode = entity.zipcode,
              let lat = entity.lat,
              let lng = entity.lng
        else {
            assertionFailure("[Error] Invalid Address entity")
            return nil
        }
        self.street = street
        self.suite = suite
        self.city = city
        self.zipcode = zipcode
        self.geo = Geo(lat: lat, lng: lng)
    }
}

struct Geo: Codable {
    let lat: String
    let lng: String
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
    
    init(
        name: String,
        catchPhrase: String,
        bs: String
    ) {
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
    
    init?(entity: CompanyEntity) {
        guard let name = entity.name,
              let catchPhrase = entity.catchPhrase,
              let bs = entity.bs
        else {
            assertionFailure("[Error] Invalid  Company entity")
            return nil
        }
        self.name = name
        self.catchPhrase = catchPhrase
        self.bs = bs
    }
}
