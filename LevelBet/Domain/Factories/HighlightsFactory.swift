//
//  HighlightsFactory.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 08.04.2026.
//

import Foundation

struct Highlights {
    let biggestWin: Int
    let biggestLoss: Int
    let longestWinStreak: Int
    let longestLossStreak: Int
    let biggestWinningOdds: Double
    let smallestLosingOdds: Double
    let biggestWinningEventOdds: Double
    let smallestLosingEventOdds: Double
    let averageCouponCountPerDay: Double
    let averageCouponCountPerWeek: Double
    let longestActiveStreak: Int
    let longestInactiveStreak: Int
    let bestWeekday: String
    let worstWeekday: String
    let bestMonth: String
    let worstMonth: String
    let biggestWinningEventCount: Int
    let mostFrequencyWinningSport: String
}

enum HighlightsFactory {
    
    // MARK: Private Methods
    private static func marginalValues(
        from groupedProfits: [Int: Int]
    ) -> (best: Int?, worst: Int?) {
        let maxEntry = groupedProfits.max { $0.value < $1.value }
        let minEntry = groupedProfits.min { $0.value < $1.value }
        let best = (maxEntry?.value ?? 0) > 0 ? maxEntry?.key ?? 0 : nil
        let worst = (minEntry?.value ?? 0) < 0 ? minEntry?.key ?? 0 : nil
        return (best, worst)
    }
    
    private static func weekdayTitle(from value: Int?) -> String {
        guard let value else { return "Неизвестно" }
        let symbols = Calendar.current.weekdaySymbols
        let index = value - 1
        guard symbols.indices.contains(index) else { return "Неизвестно" }
        return symbols[index].capitalized
    }
    
    private static func monthTitle(from value: Int?) -> String {
        guard let value else { return "Неизвестно" }
        let symbols = Calendar.current.standaloneMonthSymbols
        let index = value - 1
        guard symbols.indices.contains(index) else { return "Неизвестно" }
        return symbols[index].capitalized
    }
    
    private static func dayStreaks(
        from days: [Date]
    ) -> (active: Int, inactive: Int) {
        var longestActiveStreak = 1
        var currentActiveStreak = 1
        var longestInactiveStreak = 0
        for index in 1..<days.count {
            let previous = days[index - 1]
            let current = days[index]
            let difference = Calendar.current.dateComponents(
                [.day],
                from: previous,
                to: current).day ?? 0
            currentActiveStreak = difference == 1
            ? currentActiveStreak + 1
            : 1
            longestActiveStreak = max(longestActiveStreak, currentActiveStreak)
            if difference > 1 {
                let inactiveDays = difference - 1
                longestInactiveStreak = max(longestInactiveStreak, inactiveDays)
            }
        }
        return (longestActiveStreak, longestInactiveStreak)
    }
    
    // MARK: Public Methods
    static func make(for coupons: [Coupon]) -> Highlights {
        guard !coupons.isEmpty else {
            return .init(
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
                bestWeekday: "Неизвестно",
                worstWeekday: "Неизвестно",
                bestMonth: "Неизвестно",
                worstMonth: "Неизвестно",
                biggestWinningEventCount: 0,
                mostFrequencyWinningSport: "Неизвестно")
        }
        var biggestWin = 0
        var biggestLoss = 0
        var currentWinStreak = 0
        var currentLossStreak = 0
        var longestWinStreak = 0
        var longestLossStreak = 0
        var biggestWinningOdds = 0.0
        var smallestLosingOdds = Double.greatestFiniteMagnitude
        var biggestWinningEventOdds = 0.0
        var smallestLosingEventOdds = Double.greatestFiniteMagnitude
        var biggestWinningEventCount = 0
        var dayCounts: [Date: Int] = [:]
        var weekCounts: [Int: Int] = [:]
        var weekdayProfits: [Int: Int] = [:]
        var monthProfits: [Int: Int] = [:]
        var sportCounts: [Sports: Int] = [:]
        for coupon in coupons {
            let profit = coupon.winnings - coupon.stake
            if profit > 0 {
                biggestWin = max(biggestWin, profit)
            } else {
                biggestLoss = max(biggestLoss, -profit)
            }
            if coupon.totalStatus == .won {
                currentWinStreak += 1
                currentLossStreak = 0
                biggestWinningOdds = max(biggestWinningOdds, coupon.totalOdds)
                biggestWinningEventCount = max(
                    biggestWinningEventCount,
                    coupon.events.count)
            } else {
                currentLossStreak += 1
                currentWinStreak = 0
                smallestLosingOdds = min(smallestLosingOdds, coupon.totalOdds)
            }
            longestWinStreak = max(longestWinStreak, currentWinStreak)
            longestLossStreak = max(longestLossStreak, currentLossStreak)
            for event in coupon.events {
                if event.status == .won {
                    biggestWinningEventOdds = max(
                        biggestWinningEventOdds,
                        event.odds)
                    sportCounts[event.sport, default: 0] += 1
                } else {
                    smallestLosingEventOdds = min(
                        smallestLosingEventOdds,
                        event.odds)
                }
            }
            let day = Calendar.current.startOfDay(for: coupon.timestamp)
            dayCounts[day, default: 0] += 1
            let week = Calendar.current.component(
                .weekOfYear,
                from: coupon.timestamp)
            weekCounts[week, default: 0] += 1
            let weekday = Calendar.current.component(
                .weekday,
                from: coupon.timestamp)
            weekdayProfits[weekday, default: 0] += profit
            let month = Calendar.current.component(
                .month,
                from: coupon.timestamp)
            monthProfits[month, default: 0] += profit
        }
        if smallestLosingOdds == .greatestFiniteMagnitude {
            smallestLosingOdds = 0
        }
        if smallestLosingEventOdds == .greatestFiniteMagnitude {
            smallestLosingEventOdds = 0
        }
        let averageCouponCountPerDay = dayCounts.isEmpty
        ? 0.0
        : Double(dayCounts.values.reduce(0, +)) / Double(dayCounts.count)
        let averageCouponCountPerWeek = weekCounts.isEmpty
        ? 0.0
        : Double(weekCounts.values.reduce(0, +)) / Double(weekCounts.count)
        let daySteaks = dayStreaks(from: dayCounts.keys.sorted())
        let weekdayMarginalValues = marginalValues(from: weekdayProfits)
        let monthMarginalValues = marginalValues(from: monthProfits)
        let mostFrequencyWinningSport = sportCounts.max {
            $0.value < $1.value
        }?.key.rawValue ?? "Неизвестно"
        return .init(
            biggestWin: biggestWin,
            biggestLoss: biggestLoss,
            longestWinStreak: longestWinStreak,
            longestLossStreak: longestLossStreak,
            biggestWinningOdds: biggestWinningOdds,
            smallestLosingOdds: smallestLosingOdds,
            biggestWinningEventOdds: biggestWinningEventOdds,
            smallestLosingEventOdds: smallestLosingEventOdds,
            averageCouponCountPerDay: averageCouponCountPerDay,
            averageCouponCountPerWeek: averageCouponCountPerWeek,
            longestActiveStreak: daySteaks.active,
            longestInactiveStreak: daySteaks.inactive,
            bestWeekday: weekdayTitle(from: weekdayMarginalValues.best),
            worstWeekday: weekdayTitle(from: weekdayMarginalValues.worst),
            bestMonth: monthTitle(from: monthMarginalValues.best),
            worstMonth: monthTitle(from: monthMarginalValues.worst),
            biggestWinningEventCount: biggestWinningEventCount,
            mostFrequencyWinningSport: mostFrequencyWinningSport)
    }
}
