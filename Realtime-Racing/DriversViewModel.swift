//
//  DriversViewModel.swift
//  Realtime-Racing
//
//  Created by Alicia Bang on 10/5/2025.
//

import Foundation
import SwiftUI

class DriversViewModel: ObservableObject {
    @Published var drivers: [Drivers] = []

    init() {
        loadDriversData()
    }

    func loadDriversData() {
        guard let url = Bundle.main.url(forResource: "drivers", withExtension: "json") else {
            print("❌ Failed to locate drivers.json in app bundle.")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            self.drivers = try decoder.decode([Drivers].self, from: data)
            print("✅ Successfully loaded \(self.drivers.count) drivers.")
        } catch {
            print("❌ Failed to decode drivers data: \(error)")
        }
    }
}
