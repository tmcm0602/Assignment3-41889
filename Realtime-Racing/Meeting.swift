//
//  Meeting.swift
//  Realtime-Racing
//
//  Created by Admin on 8/5/2025.
//

import Foundation

struct Meeting: Codable, Identifiable {
    let id = UUID()
    let circuitShortName: String
    let countryName: String
    let dateStart: String
    let location: String
    let meetingName: String
    
    enum CodingKeys: String, CodingKey {
            case circuitShortName = "circuit_short_name"
            case countryName = "country_name"
            case dateStart = "date_start"
            case location
            case meetingName = "meeting_name"
        }
}
