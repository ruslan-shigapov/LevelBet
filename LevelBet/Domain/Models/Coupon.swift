//
//  Coupon.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import Foundation
import SwiftData

@Model
final class Coupon {
    
    var timestamp: Date
    var stake: Int
    var totalStatus: Statuses
    
    @Relationship(deleteRule: .cascade)
    var events: [Event] = []
    
    init(timestamp: Date, stake: Int, totalStatus: Statuses) {
        self.timestamp = timestamp
        self.stake = stake
        self.totalStatus = totalStatus
    }
}
