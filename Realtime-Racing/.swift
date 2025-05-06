//
//  LiveTimingView 2.swift
//  Realtime-Racing
//
//  Created by Admin on 6/5/2025.
//


struct LiveTimingView: View {
    @StateObject var viewModel = LiveTimingViewModel()
    @State private var isAnimating = false

    var body: some View {
        VStack {
            Text("Live Timing")
                .font(.title)
                .bold()
                .foregroundColor(.f1Red)
                .padding(.top)

            if viewModel.isSessionLive {
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
            } else {
                VStack(spacing: 20) {
                    Text("No Sessions Live Currently...")
                        .foregroundColor(.f1White)
                        .font(.headline)
                        .opacity(isAnimating ? 0.4 : 1.0)
                        .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }

            Spacer()
        }
        .background(Color.f1Black.edgesIgnoringSafeArea(.all))
        .onAppear {
            isAnimating = true
            Task { await viewModel.fetchLiveData() }
        }
    }
}
