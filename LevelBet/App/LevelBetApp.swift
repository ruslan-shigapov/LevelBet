//
//  LevelBetApp.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import SwiftData

@main
struct LevelBetApp: App {
    
    private let sharedModelContainer: ModelContainer = {
        do {
            return try ModelContainer(for: Coupon.self, Event.self)
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .modelContainer(sharedModelContainer)
                .environment(
                    CouponService(context: sharedModelContainer.mainContext))
        }
    }
}
