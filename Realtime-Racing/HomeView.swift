//
//  ContentView.swift
//  Realtime-Racing
//
//  Created by Admin on 5/5/2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: LiveTimingView()) {
                    HomeButton(title: "Live Timing", icon: "speedometer")
                }
                NavigationLink(destination: PastSessionsView()) {
                    HomeButton(title: "Past Sessions", icon: "clock.arrow.circlepath")
                }
                Spacer()
            }
            .padding()
            .navigationTitle("🏁 F1 Timing")
            .background(Color.f1Black.edgesIgnoringSafeArea(.all))
        }
    }
}

struct HomeButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.f1Red)
            Text(title)
                .font(.headline)
                .foregroundColor(.f1White)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.f1Grey)
        }
        .padding()
        .background(Color.f1Grey)
        .cornerRadius(10)
    }
}

#Preview {
    HomeView()
}
