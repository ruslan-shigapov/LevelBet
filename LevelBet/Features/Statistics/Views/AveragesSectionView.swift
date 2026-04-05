//
//  AveragesSectionView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 05.04.2026.
//

import SwiftUI

struct AveragesSectionView: View {
    
    let metrics: Averages
    
    var body: some View {
        Section("Средние") {
            AveragesView(
                title: "Сумма",
                overall: metrics.stake.overall
                    .formatted(.number.precision(.fractionLength(0))),
                won: metrics.stake.won
                    .formatted(.number.precision(.fractionLength(0))),
                lost: metrics.stake.lost
                    .formatted(.number.precision(.fractionLength(0))))
            AveragesView(
                title: "Коэф. купона",
                overall: metrics.totalOdds.overall.oddsFormatted,
                won: metrics.totalOdds.won.oddsFormatted,
                lost: metrics.totalOdds.lost.oddsFormatted)
            AveragesView(
                title: "Коэф. события",
                overall: metrics.odds.overall.oddsFormatted,
                won: metrics.odds.won.oddsFormatted,
                lost: metrics.odds.lost.oddsFormatted)
            AveragesView(
                title: "Кол-во событий",
                overall: metrics.eventCount.overall
                    .formatted(.number.precision(.fractionLength(0...1))),
                won: metrics.eventCount.won
                    .formatted(.number.precision(.fractionLength(0...1))),
                lost: metrics.eventCount.lost
                    .formatted(.number.precision(.fractionLength(0...1))))
        }
    }
}
