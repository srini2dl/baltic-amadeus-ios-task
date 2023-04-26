//
//  UserDetailView.swift
//  Baltic Amadeus iOS Task
//
//  Created by Srinivasan Raman on 2023-04-26.
//

import SwiftUI

struct UserDetailView: View {
    let userId: Int
    var body: some View {
        Text("UserId: \(userId)")
    }
}

struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(userId: 1)
    }
}
