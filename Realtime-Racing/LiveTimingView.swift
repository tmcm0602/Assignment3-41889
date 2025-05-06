//
//  LiveTimingView.swift
//  Realtime-Racing
//
//  Created by Admin on 5/5/2025.
//

import SwiftUI

struct LiveTimingView: View {
    @StateObject var viewModel = LiveTimingViewModel()

    var body: some View {
        VStack {
            Text("Live Timing")
                .font(.title)
                .bold()
                .foregroundColor(.f1Red)
                .padding(.top)

            List(viewModel.lapTimes, id: \.lapNumber) { lap in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Driver \(lap.driverNumber)")
                        .foregroundColor(.f1White)
                        .font(.headline)
                    
                    HStack {
                        TimingSlot(label: "S1", time: lap.sector1Time)
                        TimingSlot(label: "S2", time: lap.sector2Time)
                        TimingSlot(label: "S3", time: lap.sector3Time)
                        TimingSlot(label: "Lap", time: lap.lapTime)
                    }
                }
                .padding()
                .background(Color.f1Grey)
                .cornerRadius(10)
            }
        }
        .background(Color.f1Black.edgesIgnoringSafeArea(.all))
        .onAppear {
            Task { await viewModel.fetchLiveData() }
        }
    }
}

struct TimingSlot: View {
    let label: String
    let time: Double?

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .foregroundColor(.f1Red)
            Text(time != nil ? String(format: "%.3f", time!) : "--.--")
                .font(.subheadline)
                .foregroundColor(.f1White)
        }
        .frame(width: 60)
    }
}


#Preview {
    LiveTimingView()
}
