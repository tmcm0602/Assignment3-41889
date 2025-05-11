import Foundation
import SwiftUI

class LiveTimingViewModel: ObservableObject {
    @Published var lapTimes: [LapTime] = []
    @Published var drivers: [Driver] = []
    @Published var isSessionLive: Bool = false
    @Published var sessionName: String = "Live Timing"
    @Published var circuitName: String = ""
    @Published var showGapToLeader: Bool = true
    
    private let baseURL = "http://192.168.1.107:5000/api"
    private var timer: Timer?
    
    init() {
        // Initialize with Miami qualifying
        Task {
            await changeSession(type: "Qualifying", circuit: "Miami")
        }
        
        // Set up timer to fetch data every 3 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchLiveData()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
    
    func toggleGapMode() {
        showGapToLeader.toggle()
    }
    
    func fetchLiveData() async {
        do {
            // Get complete timing data from our simulator
            let url = URL(string: "\(baseURL)/timing/complete")!
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            
            // Decode the complete timing response
            let timingResponse = try decoder.decode(TimingResponse.self, from: data)
            
            // Update session information
            let sessionInfo = timingResponse.session
            
            // Get driver information if needed
            if drivers.isEmpty {
                await fetchDrivers()
            }
            
            // Process timing data
            let timing = timingResponse.timing
            var newLapTimes: [LapTime] = []
            
            for (index, entry) in timing.enumerated() {
                // Calculate gap and interval based on timing data
                let gap = entry.gap
                let interval = entry.interval
                let intervalColor: Color = entry.intervalColor == "red" ? .red : .green
                
                let lapTime = LapTime(
                    driverNumber: entry.driverNumber,
                    lapNumber: 0, // We don't have this information
                    lapTime: entry.bestLapTime,
                    sector1Time: nil, // We don't have this information
                    sector2Time: nil, // We don't have this information
                    sector3Time: nil, // We don't have this information
                    position: index + 1,
                    gap: gap,
                    interval: interval,
                    intervalColor: intervalColor,
                    tyreCompound: entry.currentTyre
                )
                
                newLapTimes.append(lapTime)
            }
            
            // Update on main thread
            await MainActor.run {
                self.lapTimes = newLapTimes
                self.sessionName = "\(sessionInfo.name) - \(sessionInfo.circuit)"
                self.circuitName = sessionInfo.circuit
                self.isSessionLive = sessionInfo.isActive
            }
            
        } catch {
            print("Error fetching timing data: \(error)")
        }
    }
    
    func fetchDrivers() async {
        do {
            let url = URL(string: "\(baseURL)/drivers")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let drivers = try JSONDecoder().decode([Driver].self, from: data)
            
            await MainActor.run {
                self.drivers = drivers
            }
        } catch {
            print("Error fetching drivers: \(error)")
        }
    }
    
    // Trigger a simulation update
    func triggerSimulation() async {
        do {
            let url = URL(string: "\(baseURL)/session/simulate")!
            let _ = try await URLSession.shared.data(from: url)
            await fetchLiveData()
        } catch {
            print("Error triggering simulation: \(error)")
        }
    }
    
    // Change session type and circuit
    func changeSession(type: String, circuit: String) async {
        do {
            let changeURL = URL(string: "\(baseURL)/session/change/\(type)/\(circuit)")!
            let _ = try await URLSession.shared.data(from: changeURL)
            
            // If session is qualifying, start simulation
            if type == "Qualifying" {
                let startURL = URL(string: "\(baseURL)/session/start_qualifying")!
                let _ = try await URLSession.shared.data(from: startURL)
            }

            await fetchLiveData()
        } catch {
            print("Error changing session: \(error)")
        }
    }

}

// Response models for the API
struct TimingResponse: Decodable {
    let session: SessionInfo
    let timing: [TimingEntry]
}

struct SessionInfo: Decodable {
    let name: String
    let circuit: String
    let country: String
    let isActive: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, circuit, country
        case isActive = "is_active"
    }
}

struct TimingEntry: Decodable {
    let driverNumber: Int
    let driverCode: String
    let teamName: String
    let teamColour: String
    let bestLapTime: Double
    let currentTyre: String
    let gap: String
    let interval: String
    let intervalColor: String
}
