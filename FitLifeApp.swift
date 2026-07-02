//
//  FitLifeApp.swift
//  FitLife
//
//  Created by Jacob on 23/06/2026.
//

import SwiftUI

@main
struct FitLifeApp: App {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                WorkoutDaysView()
                    .environmentObject(WorkoutStore())
            } else {
                OnboardingView()
            }
        }
    }
}
