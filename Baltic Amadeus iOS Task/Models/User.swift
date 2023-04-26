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
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
    
    init?(entity: AddressEntity) {
        guard let street = entity.street,
              let suit = entity.suite,
              let city = entity.city,
              let zipcode = entity.zipcode,
              let lat = entity.lat,
              let lng = entity.lng
        else {
            assertionFailure("[Error] Invalid Address entity")
            return nil
        }
        self.street = street
        self.suite = suit
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
