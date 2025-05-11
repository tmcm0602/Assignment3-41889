import SwiftUI

struct LiveTimingView: View {
    @StateObject var viewModel = LiveTimingViewModel()
    @State private var isAnimating = false
    @State private var showSessionPicker = false
    
    var body: some View {
        VStack(spacing: 2) {
            // Header with session name
            HStack {
                Text(viewModel.sessionName)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.f1Red)
                
                Spacer()
                
                Button(action: {
                    showSessionPicker.toggle()
                }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.f1White)
                }
                .padding(.trailing)
            }
            .padding(.horizontal)
            .padding(.bottom, 4)

            .background(Color.f1Black)
            
            // Column headers
            HStack(spacing: 10) {
                Text("POS")
                    .font(.caption)
                    .frame(width: 30, alignment: .leading)
                
                
                Text("CODE")
                    .font(.caption)
                    .frame(width: 50, alignment: .leading)
                
                Text("TIME")
                    .font(.caption)
                    .frame(width: 70, alignment: .trailing)
                
                Button(action: {
                    viewModel.toggleGapMode()
                }) {
                    Text(viewModel.showGapToLeader ? "GAP" : "INT")
                        .font(.caption)
                        .frame(width: 60, alignment: .trailing)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text("INT")
                    .font(.caption)
                    .frame(width: 60, alignment: .trailing)
                
                Text("TYRE")
                    .font(.caption)
                    .frame(width: 40, alignment: .leading)
            }
            .foregroundColor(.gray)
            .padding(.horizontal)
            .padding(.vertical, 4) // Removed vertical padding completely
            .background(Color.f1Black)
            
            if viewModel.lapTimes.isEmpty {
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
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Add a spacer with negative height to pull content up
                        Color.clear.frame(height: 0)
                        ForEach(Array(viewModel.lapTimes.enumerated()), id: \.element.driverNumber) { index, lapTime in
                            // Find the driver by number
                            if let driver = viewModel.drivers.first(where: { $0.driverNumber == lapTime.driverNumber }) {
                                LiveTimingRow(
                                    position: index + 1,
                                    driverCode: driver.code,
                                    teamColor: driver.teamColor,
                                    lapTime: lapTime.lapTimeFormatted,
                                    gap: viewModel.showGapToLeader || index == 0 ? lapTime.gapFormatted : "", // Show gap to leader or empty for leader
                                    interval: lapTime.intervalFormatted,
                                    intervalColor: lapTime.intervalColor,
                                    tyreImage: lapTime.tyreImage,
                                    isEvenRow: index % 2 == 0
                                )
                            }
                        }
                    }
                }
                .background(Color.f1Black)
                .refreshable {
                    Task {
                        await viewModel.triggerSimulation()
                    }
                }
            }
        }
        .background(Color.f1Black.edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showSessionPicker) {
            SessionPickerView(viewModel: viewModel)
        }
        .onAppear {
            isAnimating = true
            Task {
                await viewModel.fetchLiveData()
            }
        }
    }
}

struct SessionPickerView: View {
    @ObservedObject var viewModel: LiveTimingViewModel
    @Environment(\.presentationMode) var presentationMode
    
    let sessionTypes = ["FP1", "FP2", "FP3", "Qualifying", "Race"]
    let circuits = ["Monaco", "Miami", "Silverstone", "Spa", "Singapore"]
    
    @State private var selectedSession = "Qualifying"
    @State private var selectedCircuit = "Miami"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Session Type")) {
                    Picker("Session", selection: $selectedSession) {
                        ForEach(sessionTypes, id: \.self) { session in
                            Text(session).tag(session)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Circuit")) {
                    Picker("Circuit", selection: $selectedCircuit) {
                        ForEach(circuits, id: \.self) { circuit in
                            Text(circuit).tag(circuit)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                
                Button("Apply Changes") {
                    Task {
                        await viewModel.changeSession(type: selectedSession, circuit: selectedCircuit)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .foregroundColor(.f1Red)
            }
            .navigationTitle("Session Settings")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct LiveTimingView_Previews: PreviewProvider {
    static var previews: some View {
        LiveTimingView()
    }
}
