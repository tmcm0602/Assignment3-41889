import Foundation
import SwiftUI

struct LapTime: Decodable {
    let driverNumber: Int
    let lapNumber: Int
    let lapTime: Double?
    let sector1Time: Double?
    let sector2Time: Double?
    let sector3Time: Double?
    let position: Int
    let gap: String?
    let interval: String?
    let intervalColor: Color?
    let tyreCompound: String?
    
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
    
    var gapFormatted: String? {
        gap
    }
    
    var intervalFormatted: String? {
        interval
    }
    
    var tyreImage: Image {
        switch tyreCompound?.lowercased() {
        case "soft":
            return Image("softTyre")
        case "medium":
            return Image("mediumTyre")
        case "hard":
            return Image("hardTyre")
        case "intermediate":
            return Image("interTyre")
        case "wet":
            return Image("wetTyre")
        default:
            return Image("softTyre")
        }
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
    
    // Init for decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        driverNumber = try container.decode(Int.self, forKey: .driverNumber)
        lapNumber = try container.decode(Int.self, forKey: .lapNumber)
        lapTime = try container.decodeIfPresent(Double.self, forKey: .lapTime)
        sector1Time = try container.decodeIfPresent(Double.self, forKey: .sector1Time)
        sector2Time = try container.decodeIfPresent(Double.self, forKey: .sector2Time)
        sector3Time = try container.decodeIfPresent(Double.self, forKey: .sector3Time)
        position = try container.decodeIfPresent(Int.self, forKey: .position) ?? 0
        gap = try container.decodeIfPresent(String.self, forKey: .gap)
        interval = try container.decodeIfPresent(String.self, forKey: .interval)
        
        // Handle intervalColor as a string and convert to Color
        if let colorString = try container.decodeIfPresent(String.self, forKey: .intervalColor) {
            switch colorString {
            case "red":
                intervalColor = .red
            case "green":
                intervalColor = .green
            default:
                intervalColor = .white
            }
        } else {
            intervalColor = nil
        }
        
        tyreCompound = try container.decodeIfPresent(String.self, forKey: .tyreCompound)
    }
    
    // CodingKeys for decoding
    enum CodingKeys: String, CodingKey {
        case driverNumber, lapNumber, lapTime, sector1Time, sector2Time, sector3Time, position, gap, interval, intervalColor, tyreCompound
    }
    
    // Manual init for use within app
    init(driverNumber: Int, lapNumber: Int, lapTime: Double?, sector1Time: Double?, sector2Time: Double?, sector3Time: Double?, position: Int = 0, gap: String? = nil, interval: String? = nil, intervalColor: Color? = nil, tyreCompound: String? = nil) {
        self.driverNumber = driverNumber
        self.lapNumber = lapNumber
        self.lapTime = lapTime
        self.sector1Time = sector1Time
        self.sector2Time = sector2Time
        self.sector3Time = sector3Time
        self.position = position
        self.gap = gap
        self.interval = interval
        self.intervalColor = intervalColor
        self.tyreCompound = tyreCompound
    }
}
