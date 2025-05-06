import Foundation

struct LapTime: Decodable {
    let driverNumber: Int
    let lapNumber: Int
    let lapTime: Double?
    let sector1Time: Double?
    let sector2Time: Double?
    let sector3Time: Double?
    
    // Computed properties for formatted values
    var lapTimeFormatted: String? {
        formatTime(lapTime)
    }
    
    var sector1TimeFormatted: String? {
        formatTime(sector1Time)
    }
    
    var sector2TimeFormatted: String? {
        formatTime(sector2Time)
    }
    
    var sector3TimeFormatted: String? {
        formatTime(sector3Time)
    }
    
    // In a real app, these would be calculated against leader/previous car
    var gapFormatted: String? {
        "+0.342"  // Placeholder
    }
    
    var intervalFormatted: String? {
        "+0.122"  // Placeholder
    }
    
    // Helper method to format times
    private func formatTime(_ time: Double?) -> String? {
        guard let time = time else { return nil }
        
        let minutes = Int(time) / 60
        let seconds = time.truncatingRemainder(dividingBy: 60)
        
        if minutes > 0 {
            return String(format: "%d:%06.3f", minutes, seconds)
        } else {
            return String(format: "%.3f", seconds)
        }
    }
}
