//
//  CuriousSectionView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 14.05.2026.
//

import SwiftUI

struct CuriousSectionView: View {
    
    // MARK: Public Properties
    let metrics: Highlights
    
    // MARK: Body
    var body: some View {
        Section("Любопытное") {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())]
            ) {
                CuriousCard(
                    title: "max результаты",
                    firstLabel: "Чист. выигр.",
                    firstValue: metrics.biggestWin.formatted(),
                    secondLabel: "Проигрыш",
                    secondValue: metrics.biggestLoss.formatted())
                CuriousCard(
                    title: "max серии",
                    firstLabel: "Выигрышей",
                    firstValue: metrics.longestWinStreak.formatted(),
                    secondLabel: "Проигрышей",
                    secondValue: metrics.longestLossStreak.formatted())
                CuriousCard(
                    title: "Коэф. купонов",
                    firstLabel: "max выигр.",
                    firstValue: metrics.biggestWinningOdds.oddsFormatted,
                    secondLabel: "min проигр.",
                    secondValue: metrics.smallestLosingOdds.oddsFormatted)
                CuriousCard(
                    title: "Коэф. событий",
                    firstLabel: "max выигр.",
                    firstValue: metrics.biggestWinningEventOdds.oddsFormatted,
                    secondLabel: "min проигр.",
                    secondValue: metrics.smallestLosingEventOdds.oddsFormatted)
                CuriousCard(
                    title: "Кол-во купонов",
                    firstLabel: "Средн. в день",
                    firstValue: metrics.averageCouponCountPerDay
                        .formatted(.number.precision(.fractionLength(0...1))),
                    secondLabel: "Средн. в неделю",
                    secondValue: metrics.averageCouponCountPerWeek
                        .formatted(.number.precision(.fractionLength(0...1))))
                CuriousCard(
                    title: "max серии дней",
                    firstLabel: "Активных",
                    firstValue: metrics.longestActiveStreak.formatted(),
                    secondLabel: "Неактивных",
                    secondValue: metrics.longestInactiveStreak.formatted())
                CuriousCard(
                    title: "Дни недели",
                    firstLabel: "Лучший",
                    firstValue: metrics.bestWeekday,
                    secondLabel: "Худший",
                    secondValue: metrics.worstWeekday)
                CuriousCard(
                    title: "Месяцы",
                    firstLabel: "Лучший",
                    firstValue: metrics.bestMonth,
                    secondLabel: "Худший",
                    secondValue: metrics.worstMonth)
                CuriousCard(
                    title: "Самый длинный выигр. экспресс",
                    firstLabel: "Событий",
                    firstValue: metrics.biggestWinningEventCount.formatted(),
                    secondLabel: "",
                    secondValue: "")
                CuriousCard(
                    title: "Самый выигр. вид спорта",
                    firstLabel: "",
                    firstValue: metrics.mostFrequencyWinningSport,
                    secondLabel: "",
                    secondValue: "")
            }
            .listRowInsets(.init())
            .listRowBackground(Color.clear)
        }
    }
}

// MARK: - Views
private extension CuriousSectionView {
    
    func CuriousCard(
        title: String,
        firstLabel: String,
        firstValue: String,
        secondLabel: String,
        secondValue: String
    ) -> some View {
        VStack(alignment: .leading, spacing: Layouts.mediumOffset) {
            Text(title)
                .font(.callout.weight(.medium))
            VStack {
                LabeledContent(firstLabel, value: firstValue)
                if !secondLabel.isEmpty {
                    LabeledContent(secondLabel, value: secondValue)
                }
            }
            .font(.footnote.weight(.light).italic())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(uiColor: .secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
