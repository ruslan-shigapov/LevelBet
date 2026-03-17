//
//  MetricFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 09.03.2026.
//

import Foundation

enum MetricFactory {
    
    struct Summary {
        let settledCount: Int
        let totalStake: Int
        let profit: Int
        let roi: Double
        let winRate: Double
    }
    
    struct Breakdown {
        
    }
    
    static func profit(for coupons: [Coupon]) -> Int {
        var totalWinnings = 0
        var totalStake = 0
        for coupon in coupons {
            guard coupon.totalStatus != .pending else { continue }
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
        }
        guard totalStake > 0 else { return 0 }
        return totalWinnings - totalStake
    }
    
    static func summary(for coupons: [Coupon]) -> Summary {
        var totalStake = 0
        var totalWinnings = 0
        var wins = 0
        for coupon in coupons {
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
            if coupon.totalStatus == .won {
                wins += 1
            }
        }
        let profit = totalWinnings - totalStake
        let roi = totalStake > 0 ? Double(profit) / Double(totalStake) : 0
        let winRate = coupons.isEmpty ? 0 : Double(wins) / Double(coupons.count)
        return Summary(
            settledCount: coupons.count,
            totalStake: totalStake,
            profit: profit,
            roi: roi,
            winRate: winRate)
    }
}
