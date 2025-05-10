//
//  DriversListView.swift
//  Realtime-Racing
//
//  Created by Alicia Bang on 10/5/2025.
//

import SwiftUI

struct DriverListView: View {
    @ObservedObject var viewModel = DriversViewModel()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                Text("F1 Drivers Leaderboard")
                    .font(.largeTitle.bold())
                    .foregroundColor(.f1White)
                    .padding([.horizontal, .top])
                
                Rectangle()
                    .fill(Color.f1Red)
                    .frame(height: 1)
                    .padding([.horizontal])

                List(viewModel.drivers) { driver in
                    NavigationLink(destination: DriverDetailView(driver: driver)) {
                        HStack(spacing: 12) {
                            Text("\(driver.driverKey)")
                                .font(.caption)
                                .foregroundColor(.f1LightGrey)
                                .frame(alignment: .leading)
                            
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

                            Text("\(driver.points) pts")
                                .font(.subheadline)
                                .foregroundColor(.f1Red)
                        }
                        .padding()
                        .background(Color.f1Grey)
                        .cornerRadius(15)
                        .padding(.vertical, 5)
                    }
                    .listRowBackground(Color.f1Black)
                }
                .listStyle(.plain)
                .background(Color.f1Black)
            }
            .background(Color.f1Black)
        }
        .accentColor(.f1Red)
    }
}

struct DriverDetailView: View {
    let driver: Drivers

    var body: some View {
        ZStack {
            Color.f1Black
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    
                    HStack(alignment: .center, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(driver.fullName)
                                .font(.largeTitle)
                                .bold()
                                .foregroundColor(.f1White)

                            Text(driver.team)
                                .font(.title2)
                                .foregroundColor(.f1LightGrey)
                                .bold()
                                .italic()
                        }

                        Spacer()

                        AsyncImage(url: URL(string: driver.driverPortrait)) { image in
                            image.resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.f1Red, lineWidth: 2))
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    .padding(.horizontal)

                    Divider()
                        .frame(height: 1)
                        .background(Color.f1Red)
                        .padding(.horizontal)

                    HStack(spacing: 16) {
                        // 2025 stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("2025 Season")
                                .font(.headline)
                                .foregroundColor(.f1Red)

                            Group {
                                Text("Points: \(driver.points)")
                                Text("Podiums: \(driver.podiums)")
                                Text("Fastest Laps: \(driver.fastestLaps)")
                                Text("GPs Entered: \(driver.gpsEntered)")
                            }
                            .foregroundColor(.f1White)
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color.f1Grey)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity)

                        // Career stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Career")
                                .font(.headline)
                                .foregroundColor(.f1Red)

                            Group {
                                Text("Points: \(driver.careerPoints)")
                                Text("Podiums: \(driver.careerPodiums)")
                                Text("Fastest Laps: \(driver.careerFastestLaps)")
                                Text("GPs Entered: \(driver.careerGpsEntered)")
                            }
                            .foregroundColor(.f1White)
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color.f1Grey)
                        .cornerRadius(15)
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
        }
    }
}

#Preview {
    DriverListView()
}
