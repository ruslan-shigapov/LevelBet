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
    var odds: Decimal
    var status: Statuses
    var coupon: Coupon?
    
    init(
        sport: Sports,
        odds: Decimal,
        status: Statuses = .pending,
        coupon: Coupon?
    ) {
        self.sport = sport
        self.odds = odds
        self.status = status
        self.coupon = coupon
    }
}
