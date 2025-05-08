//
//  PastSessionsView.swift
//  Realtime-Racing
//
//  Created by Admin on 5/5/2025.
//

import SwiftUI

struct PastSessionsView: View {
    @StateObject private var viewModel = MeetingViewModel()

    var body: some View {
        List(viewModel.meetings) { meeting in
            VStack(alignment: .leading, spacing: 5) {
                Text(meeting.meetingName)
                    .font(.headline)
                    .foregroundColor(.f1White)
                Text("View session details")
                    .font(.caption)
                    .foregroundColor(.f1White)
            }
            .padding()
            .background(Color.f1Black)
            .cornerRadius(10)
        }
        .navigationTitle("Past Sessions")
        .background(Color.f1Black.edgesIgnoringSafeArea(.all))
    }
}


#Preview {
    PastSessionsView()
}
