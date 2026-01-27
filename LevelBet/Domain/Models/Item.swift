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
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
