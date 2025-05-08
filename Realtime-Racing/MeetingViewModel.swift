//
//  MeetingViewModel.swift
//  Realtime-Racing
//
//  Created by Admin on 8/5/2025.
//

import Foundation
import SwiftUI

class MeetingViewModel: ObservableObject {
    @Published var meetings: [Meeting] = []

    init() {
        loadMeetings()
    }
    
    func loadJSONFromFile<T: Decodable>(_ type: T.Type, fileName: String) -> T? {
            let decoder = JSONDecoder()

            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                print("❌ File not found in bundle.")
                return nil
            }

            do {
                let data = try Data(contentsOf: url)
                let decoded = try decoder.decode(T.self, from: data)
                return decoded
            } catch {
                print("❌ Failed to decode JSON: \(error)")
                return nil
            }
        }

        func loadMeetings() {
            if let loaded: [Meeting] = loadJSONFromFile([Meeting].self, fileName: "meeting") {
                self.meetings = loaded
            }
        }
}
