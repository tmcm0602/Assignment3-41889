//
//  Drivers.swift
//  Realtime-Racing
//
//  Created by Alicia Bang on 10/5/2025.
//

import Foundation

struct Drivers: Identifiable, Codable {
    var id: Int { driverKey }

    let driverKey: Int
    let fullName: String
    let team: String
    let imageUrl: String
    let driverPortrait: String
    let shortName: String
    let season2025: SeasonStats
    let career: CareerStats

    var points: Int { season2025.points }
    var podiums: Int { season2025.podiums }
    var fastestLaps: Int { season2025.fastestLaps }
    var gpsEntered: Int { season2025.gpsEntered }

    var careerPoints: Int { career.points }
    var careerPodiums: Int { career.podiums }
    var careerFastestLaps: Int { career.fastestLaps }
    var careerGpsEntered: Int { career.gpsEntered }

    struct SeasonStats: Codable {
        let points: Int
        let podiums: Int
        let fastestLaps: Int
        let gpsEntered: Int

        enum CodingKeys: String, CodingKey {
            case points, podiums, fastestLaps = "fastest_laps", gpsEntered = "gps_entered"
        }
    }

    struct CareerStats: Codable {
        let points: Int
        let podiums: Int
        let fastestLaps: Int
        let gpsEntered: Int

        enum CodingKeys: String, CodingKey {
            case points, podiums, fastestLaps = "fastest_laps", gpsEntered = "gps_entered"
        }
    }

    enum CodingKeys: String, CodingKey {
        case driverKey = "driver_key"
        case fullName = "full_name"
        case team
        case imageUrl = "image_url"
        case driverPortrait = "driver_portrait"
        case shortName = "short_name"
        case season2025 = "2025"
        case career
    }
}
