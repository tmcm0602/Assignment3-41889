import SwiftUI
import Foundation

struct Driver: Decodable, Identifiable {
    var id: Int { driverNumber }

    let driverNumber: Int
    let fullName: String
    let teamName: String
    let teamColour: String // e.g., "#FF0000"
    let headshotUrl: String
    let code: String
    
    var teamColor: Color {
        Color(hex: teamColour) ?? .white
    }
    
    // CodingKeys for JSON parsing
    enum CodingKeys: String, CodingKey {
        case driverNumber
        case fullName
        case teamName
        case teamColour
        case headshotUrl
        case code
    }
}

