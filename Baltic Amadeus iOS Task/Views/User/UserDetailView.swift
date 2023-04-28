//
//  UserDetailView.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                topSection
                contactButtons
                Divider()
                contactDetails
                Divider()
                addressDetails
                Divider()
                companyDetails
                Spacer()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    var topSection: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.largeTitle)
                Text("@\(user.username)")
                    .foregroundColor(.gray)
            }
            .padding(.leading, 16)
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
    }
    
    var contactButtons: some View {
        HStack(spacing: 32) {
            Button(action: {}) {
                Label("Call", systemImage: "phone.fill")
            }
            Button(action: {}) {
                Label("Message", systemImage: "message.fill")
            }
            Button(action: {}) {
                Label("Email", systemImage: "envelope.fill")
            }
        }
        .padding(.horizontal, 16)
    }
    
    var contactDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                Text("Phone")
                    .font(.headline)
                Text(user.phone)
            }
            .padding(.horizontal, 16)
            Group {
                Text("Email")
                    .font(.headline)
                Text(user.email)
            }
            .padding(.horizontal, 16)
        }
    }
    
    var addressDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                Text("Address")
                    .font(.headline)
                Text("\(user.address.street), \(user.address.suite)")
                Text("\(user.address.city), \(user.address.zipcode)")
            }
            .padding(.horizontal, 16)
        }
    }
    
    var companyDetails: some View {
        VStack(alignment: .leading, spacing: 12) {
            Group {
                Text("Company")
                    .font(.headline)
                Text(user.company.name)
            }
            .padding(.horizontal, 16)
            Group {
                Text("Catch Phrase")
                    .font(.headline)
                Text(user.company.catchPhrase)
            }
            .padding(.horizontal, 16)
            Group {
                Text("Business")
                    .font(.headline)
                Text(user.company.bs)
            }
            .padding(.horizontal, 16)
        }
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: User.mock)
    }
}
