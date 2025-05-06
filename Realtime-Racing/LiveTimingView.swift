import SwiftUI

struct LiveTimingView: View {
    @StateObject var viewModel = LiveTimingViewModel()
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Live Timing")
                .font(.title2)
                .bold()
                .foregroundColor(.f1Red)
                .padding(.top)

            HStack {
                Text("POSITION").font(.caption).frame(width: 70, alignment: .leading)
                Text("LAP TIME").font(.caption).frame(width: 70, alignment: .trailing)
                Text("GAP").font(.caption).frame(width: 60, alignment: .trailing)
                Text("INT").font(.caption).frame(width: 60, alignment: .trailing)
                Text("TYRE").font(.caption).frame(width: 40, alignment: .leading)
            }
            .foregroundColor(.gray)
            .padding(.horizontal)

            if viewModel.drivers.isEmpty {
                ZStack {
                    Color.f1Black
                    VStack {
                        Text("No Sessions Live Currently...")
                            .foregroundColor(.gray)
                            .padding()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .f1Red))
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else {
                List {
                    ForEach(viewModel.drivers.indices, id: \.self) { i in
                        let driver = viewModel.drivers[i]
                        let lapData = viewModel.lapTimes.first(where: { $0.driverNumber == driver.driverNumber })

                        LiveTimingRow(
                            position: i + 1,
                            driverCode: driver.code,
                            teamColor: driver.teamColor,
                            lapTime: lapData?.lapTimeFormatted,
                            gap: lapData?.gapFormatted,
                            interval: lapData?.intervalFormatted,
                            tyreImage: Image(systemName: "circle.fill"),  // Placeholder
                            isPlaceholder: !viewModel.isSessionLive
                        )
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .background(Color.f1Black.edgesIgnoringSafeArea(.all))
        .onAppear {
            isAnimating = true
            Task { await viewModel.fetchLiveData() }
        }
    }
    
    // Helper function moved to LapTime model
}
