//
//  MetricFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 09.03.2026.
//

import Foundation

struct MetricFactory {
    
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
    
    static func totalWinnings(for coupons: [Coupon]) -> Int {
        coupons.reduce(0) { $0 + $1.winnings }
    }
    
    static func totalStake(for coupons: [Coupon]) -> Int {
        coupons.reduce(0) { $0 + $1.stake }
    }
    
    static func settledCount(for coupons: [Coupon]) -> Int {
        coupons.reduce(0) { $1.totalStatus != .pending ? $0 + 1 : $0 }
    }
    
    static func roi(for coupons: [Coupon]) -> Double {
        var totalWinnings = 0
        var totalStake = 0
        for coupon in coupons {
            guard coupon.totalStatus != .pending else { continue }
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
        }
        guard totalStake > 0 else { return 0 }
        let profit = totalWinnings - totalStake
//        let rawValue = Double(profit) / Double(totalStake) * 100
//        return rawValue.formatted(.number.precision(.fractionLength(2)).sign(strategy: .always())) OR INT?
        return Double(profit) / Double(totalStake) * 100
    }
    
    static func winRate(for coupons: [Coupon]) -> Double {
        var wins = 0
        var losses = 0
        for coupon in coupons {
            switch coupon.totalStatus {
            case .won: wins += 1
            case .lost: losses += 1
            default: continue
            }
        }
        let settled = wins + losses
        guard settled > 0 else { return 0 }
        return Double(wins) / Double(settled) * 100
    }
}
