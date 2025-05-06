//
//  LiveTimingViewModel.swift
//  Realtime-Racing
//
//  Created by Admin on 5/5/2025.
//

import Foundation
class LiveTimingViewModel: ObservableObject {
    @Published var lapTimes: [LapTime] = []
    @Published var tyreStints: [TyreStint] = []
    @Published var drivers: [Driver] = []

    func fetchLiveData() async {
        // Implement API calls to fetch lap times, tyre stints, and driver info
    }
}
