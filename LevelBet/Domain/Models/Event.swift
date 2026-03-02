//
//  Event.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 26.01.2026.
//

import SwiftData
import Foundation

@Model
final class Event {
    
    var sport: Sports
    var odds: Double
    var status: Statuses
    var coupon: Coupon?
    
    init(
        sport: Sports,
        odds: Double,
        status: Statuses = .pending,
    ) {
        self.sport = sport
        self.odds = odds
        self.status = status
    }
}
