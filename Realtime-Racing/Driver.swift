//
//  Driver.swift
//  Realtime-Racing
//
//  Created by Admin on 5/5/2025.
//

import SwiftUI
import Foundation

struct Driver: Decodable, Identifiable {
    var id: Int { driverNumber }

    let driverNumber: Int
    let fullName: String
    let teamName: String
    let teamColour: String // e.g., "#FF0000"
    let headshotUrl: String

    // Add computed properties for UI
    var code: String {
        // Return 3-letter code from name, or provide mapping if needed
        let parts = fullName.split(separator: " ")
        return parts.last?.prefix(3).uppercased() ?? "DRI"
    }

    var teamColor: Color {
        Color(hex: teamColour) ?? .white
    }

    var currentTyreImageName: String? {
        // Placeholder: update this when you assign real data
        "soft" // or "medium", "hard"
    }
}

