//
//  HighlightsFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 08.04.2026.
//

struct Highlights {
    let biggestWin: Int
    let biggestLoss: Int
    let longestWinStreak: Int
    let longestLossStreak: Int
    let biggestWinningOdds: Double
    let smallestLosingOdds: Double
    let biggestWinningEventOdds: Double
    let smallestLosingEventOdds: Double
    let averageCouponCountPerDay: Int
    let averageCouponCountPerWeek: Int
    let longestActiveStreak: Int
    let longestInactiveStreak: Int
    let bestWeekday: String
    let worstWeekday: String
    let bestMonth: String
    let worstMonth: String
    let biggestWinningEventCount: Int
    let mostFrequencySport: String
}

enum HighlightsFactory {
    
    static func make(for coupons: [Coupon]) -> Highlights {
        .init(
            biggestWin: 0,
            biggestLoss: 0,
            longestWinStreak: 0,
            longestLossStreak: 0,
            biggestWinningOdds: 0,
            smallestLosingOdds: 0,
            biggestWinningEventOdds: 0,
            smallestLosingEventOdds: 0,
            averageCouponCountPerDay: 0,
            averageCouponCountPerWeek: 0,
            longestActiveStreak: 0,
            longestInactiveStreak: 0,
            bestWeekday: "Среда",
            worstWeekday: "Вторник",
            bestMonth: "Апрель",
            worstMonth: "Март",
            biggestWinningEventCount: 0,
            mostFrequencySport: Sports.football.rawValue)
    }
}
