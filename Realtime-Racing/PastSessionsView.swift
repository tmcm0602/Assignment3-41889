//
//  PastSessionsView.swift
//  Realtime-Racing
//
//  Created by Admin on 5/5/2025.
//

import SwiftUI

struct PastSessionsView: View {
    let pastSessions = ["Australia GP - Race", "Bahrain GP - Qualifying", "Monaco GP - Practice 3"] // Mock data

    var body: some View {
        List(pastSessions, id: \.self) { session in
            VStack(alignment: .leading, spacing: 5) {
                Text(session)
                    .font(.headline)
                    .foregroundColor(.f1White)
                Text("View session details")
                    .font(.caption)
                    .foregroundColor(.f1Grey)
            }
            .padding()
            .background(Color.f1Grey)
            .cornerRadius(10)
        }
        .navigationTitle("Past Sessions")
        .background(Color.f1Black.edgesIgnoringSafeArea(.all))
    }
}


#Preview {
    PastSessionsView()
}
