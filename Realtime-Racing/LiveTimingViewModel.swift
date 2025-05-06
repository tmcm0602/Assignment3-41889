import Foundation

class LiveTimingViewModel: ObservableObject {
    @Published var lapTimes: [LapTime] = []
    @Published var drivers: [Driver] = []
    @Published var isSessionLive: Bool = false

    func fetchLiveData() async {
        // Simulate delay (API latency)
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        // Create local variables
        let isLive = Bool.random()
        var newDrivers: [Driver] = []
        var newLapTimes: [LapTime] = []
        
        // Simulate live or no session randomly
        if isLive {
            // Simulated drivers
            newDrivers = [
                Driver(driverNumber: 44, fullName: "Lewis Hamilton", teamName: "Mercedes", teamColour: "#00D2BE", headshotUrl: ""),
                Driver(driverNumber: 1, fullName: "Max Verstappen", teamName: "Red Bull", teamColour: "#1E41FF", headshotUrl: "")
            ]

            // Simulated lap times
            newLapTimes = [
                LapTime(driverNumber: 44, lapNumber: 12, lapTime: 92.345, sector1Time: 30.1, sector2Time: 30.6, sector3Time: 31.5),
                LapTime(driverNumber: 1, lapNumber: 12, lapTime: 91.876, sector1Time: 29.9, sector2Time: 30.3, sector3Time: 31.6)
            ]
        }
        
        // Update the @Published properties on the main thread
        await MainActor.run {
            self.drivers = newDrivers
            self.lapTimes = newLapTimes
            self.isSessionLive = isLive
        }
    }
}

