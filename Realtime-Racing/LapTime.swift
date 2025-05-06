//
//  LapTime.swift
//  Realtime-Racing
//
//  Created by Admin on 5/5/2025.
//

import Foundation
struct LapTime: Decodable {
    let driverNumber: Int
    let lapNumber: Int
    let lapTime: Double?
    let sector1Time: Double?
    let sector2Time: Double?
    let sector3Time: Double?
}
