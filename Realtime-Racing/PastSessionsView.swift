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
        ScrollView {
            VStack(spacing: 16) {
                Text("Past Sessions")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)

                ForEach(Array(viewModel.meetings.enumerated()), id: \.1.id) { index, meeting in
                        SessionRowView(index: index, meeting: meeting)
                }
            }
            .padding(.top)
        }
        .background(Color.black.ignoresSafeArea())
    }
    
    struct SessionRowView: View {
        let index: Int
        let meeting: Meeting // Use your actual model

        var body: some View {
            VStack(spacing: 0) {
                HStack(alignment: .center, spacing: 12) {
                    Text("\(index + 1)")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .frame(width: 30)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(meeting.meetingName)
                            .font(.headline)
                            .foregroundColor(.white)
                        NavigationLink(destination: SessionDetailView(meeting: meeting)) {
                            Text("Results")
                                .font(.caption)
                                .foregroundColor(.red)
                            }
                    }
                    Spacer()

                }
                .padding()

                Divider()
                    .background(Color.black.opacity(0.4)) // Subtle divider inside card
                    .padding(.horizontal, 12)
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            .padding(.horizontal)
        }
    }
}


#Preview {
    NavigationStack {
            PastSessionsView()
        }
}
