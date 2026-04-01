//
//  MetricFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 09.03.2026.
//

import Foundation

private struct Accumulator {
    var sum = 0.0
    var count = 0
    
    mutating func add(_ value: Double) {
        sum += value
        count += 1
    }
    
    var average: Double {
        count == 0 ? 0 : sum / Double(count)
    }
}

enum MetricFactory {
    
    // MARK: Summary
    struct Summary {
        let profit: Int
        let roi: Double
        let totalStake: Int
        let settledCount: Int
        let winRate: Double
        let eventWinRate: Double
    }
    
    // MARK: Averages
    struct Averages {
        
        struct Value {
            
            let overall: Double
            let won: Double
            let lost: Double
            
            static func average(
                for coupons: [Coupon],
                metric: (Coupon) -> Double
            ) -> Self {
                var overallAccumulator = Accumulator()
                var wonAccumulator = Accumulator()
                var lostAccumulator = Accumulator()
                for coupon in coupons {
                    let value = metric(coupon)
                    switch coupon.totalStatus {
                    case .won:
                        wonAccumulator.add(value)
                        overallAccumulator.add(value)
                    case .lost:
                        lostAccumulator.add(value)
                        overallAccumulator.add(value)
                    default: break
                    }
                }
                
                return .init(
                    overall: overallAccumulator.average,
                    won: wonAccumulator.average,
                    lost: lostAccumulator.average)
            }
            
            static func averageOdds(for coupons: [Coupon]) -> Self {
                var overallAccumulator = Accumulator()
                var wonAccumulator = Accumulator()
                var lostAccumulator = Accumulator()
                for coupon in coupons {
                    for event in coupon.events {
                        overallAccumulator.add(event.odds)
                        switch event.status {
                        case .won: wonAccumulator.add(event.odds)
                        case .lost: lostAccumulator.add(event.odds)
                        default: break
                        }
                    }
                }
                return .init(
                    overall: overallAccumulator.average,
                    won: wonAccumulator.average,
                    lost: lostAccumulator.average)
            }
        }
        
        let stake: Value
        let totalOdds: Value
        let odds: Value
        let eventCount: Value
    }
    
    // MARK: Private Methods
    private static func eventWinRate(for coupons: [Coupon]) -> Double {
        var total = 0
        var won = 0
        for coupon in coupons {
            for event in coupon.events {
                total += 1
                if event.status == .won {
                    won += 1
                }
            }
        }
        return total > 0 ? Double(won) / Double(total) : 0
    }
    
    // MARK: Public Methods
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
        var won = 0
        for coupon in coupons {
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
            if coupon.totalStatus == .won {
                won += 1
            }
        }
        let profit = totalWinnings - totalStake
        let roi = totalStake > 0 ? Double(profit) / Double(totalStake) : 0
        let winRate = Double(won) / Double(coupons.count)
        return .init(
            profit: profit,
            roi: roi,
            totalStake: totalStake,
            settledCount: coupons.count,
            winRate: winRate,
            eventWinRate: eventWinRate(for: coupons))
    }
    
    static func averages(for coupons: [Coupon]) -> Averages {
        .init(
            stake: .average(for: coupons) { Double($0.stake) },
            totalOdds: .average(for: coupons) { $0.totalOdds },
            odds: .averageOdds(for: coupons),
            eventCount: .average(for: coupons) { Double($0.events.count) })
    }
    
    static func roi(
        for coupons: [Coupon],
        byEventRange eventRange: EventRange
    ) -> Double {
        let filtered = coupons.filter {
            eventRange.matches(count: $0.events.count)
        }
        var totalStake = 0
        var totalWinnings = 0
        for coupon in filtered {
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
        }
        return totalStake > 0
        ? Double(totalWinnings - totalStake) / Double(totalStake)
        : 0
    }
    
    static func roi(
        for coupons: [Coupon],
        byOddsRange oddsRange: OddsRange
    ) -> Double {
        let filtered = coupons.filter {
            oddsRange.matches(odds: $0.totalOdds)
        }
        var totalStake = 0
        var totalWinnings = 0
        for coupon in filtered {
            totalWinnings += coupon.winnings
            totalStake += coupon.stake
        }
        return totalStake > 0
        ? Double(totalWinnings - totalStake) / Double(totalStake)
        : 0
    }
    
    static func winRate(
        for coupons: [Coupon],
        byEventRange eventRange: EventRange
    ) -> Double {
        let filtered = coupons.filter {
            eventRange.matches(count: $0.events.count)
        }
        guard !filtered.isEmpty else { return 0 }
        var wins = 0
        for coupon in filtered {
            if coupon.totalStatus == .won {
                wins += 1
            }
        }
        return Double(wins) / Double(filtered.count)
    }
    
    static func winRate(
        for coupons: [Coupon],
        byOddsRange oddsRange: OddsRange
    ) -> Double {
        let filtered = coupons.filter {
            oddsRange.matches(odds: $0.totalOdds)
        }
        guard !filtered.isEmpty else { return 0 }
        var wins = 0
        for coupon in filtered {
            if coupon.totalStatus == .won {
                wins += 1
            }
        }
        return Double(wins) / Double(filtered.count)
    }
    
    static func eventWinRate(
        for coupons: [Coupon],
        byEventOddsRange oddsRange: EventOddsRange
    ) -> Double {
        var total = 0
        var won = 0
        for coupon in coupons {
            for event in coupon.events {
                if oddsRange.matches(odds: event.odds) {
                    total += 1
                    if event.status == .won {
                        won += 1
                    }
                }
            }
        }
        return total > 0 ? Double(won) / Double(total) : 0
    }
    
    static func eventWinRate(
        for coupons: [Coupon],
        bySport sport: Sports
    ) -> Double {
        var total = 0
        var won = 0
        for coupon in coupons {
            for event in coupon.events {
                if event.sport == sport {
                    total += 1
                    if event.status == .won {
                        won += 1
                    }
                }
            }
        }
        return total > 0 ? Double(won) / Double(total) : 0
    }
}
