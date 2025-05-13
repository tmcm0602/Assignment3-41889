//
//  SessionDetailView.swift
//  Realtime-Racing
//
//  Created by Admin on 12/5/2025.
//

import SwiftUI

struct SessionDetailView: View {
    let meeting: Meeting
    @StateObject private var driversViewModel = DriversViewModel()

    var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Text(meeting.meetingName)
                    .font(.largeTitle.bold())
                    .foregroundColor(.f1White)
                    .padding([.horizontal, .top])
                
                Spacer()

                Rectangle()
                    .fill(Color.f1Red)
                    .frame(height: 1)
                    .padding([.horizontal])

                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(meeting.results.sorted(by: { $0.position < $1.position }), id: \.driverNumber) { result in
                            if let driver = driversViewModel.driver(for: result.driverNumber) {
                                HStack(spacing: 12) {
                                    Rectangle()
                                        .fill(Color.f1Red)
                                        .frame(width: 1, height: 40)

                                    AsyncImage(url: URL(string: driver.imageUrl)) { image in
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.f1Red, lineWidth: 2))
                                    } placeholder: {
                                            ProgressView()
                                    }

                                    VStack(alignment: .leading) {
                                        Text(driver.fullName)
                                            .font(.headline)
                                            .foregroundColor(.f1White)
                                        Text(driver.team)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }

                                    Spacer()

                                    Text("P\(result.position)")
                                        .font(.subheadline)
                                        .foregroundColor(.f1Red)
                                }
                                .padding()
                                .background(Color.f1Grey)
                                .cornerRadius(15)
                            }
                        }
                    }
                    .padding()
                }
            }
            .background(Color.f1Black.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
}

#Preview {
    SessionDetailView(meeting: Meeting(circuitShortName:"Shanghai",
                              countryName:"China",
                              dateStart:"2025-03-21T03:30:00",
                              location:"Shanghai",
                              meetingName:"Chinese Grand Prix",
                                       results: [Result(driverNumber: 1, position: 1),
                                                 Result(driverNumber: 16, position: 2),
                                                 Result(driverNumber: 4, position: 3)]))
}
