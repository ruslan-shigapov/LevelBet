//
//  ProfileView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
        
    @Query private var coupons: [Coupon]
    
    var body: some View {
        List {
            Section("Банк") {}
            CuriousSection(metrics: HighlightsFactory.make(for: coupons))
        }
        .background(Color.lightMidnight)
    }
    
    private func CuriousSection(metrics: Highlights) -> some View {
        Section("Любопытное") {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())]
            ) {
                CuriousCard(
                    title: "Макс. результаты",
                    firstLabel: "Выигрыш",
                    firstValue: metrics.biggestWin.formatted(),
                    secondLabel: "Проигрыш",
                    secondValue: metrics.biggestLoss.formatted())
                CuriousCard(
                    title: "Макс. серии",
                    firstLabel: "Выигрышей",
                    firstValue: metrics.longestWinStreak.formatted(),
                    secondLabel: "Проигрышей",
                    secondValue: metrics.longestLossStreak.formatted())
                CuriousCard(
                    title: "Коэф. купонов",
                    firstLabel: "Макс. выигр.",
                    firstValue: metrics.biggestWinningOdds.formatted(),
                    secondLabel: "Мин. проигр.",
                    secondValue: metrics.smallestLosingOdds.formatted())
                CuriousCard(
                    title: "Коэф. событий",
                    firstLabel: "Макс. выигр.",
                    firstValue: metrics.biggestWinningEventOdds.formatted(),
                    secondLabel: "Мин. проигр.",
                    secondValue: metrics.smallestLosingEventOdds.formatted())
                CuriousCard(
                    title: "Кол-во купонов",
                    firstLabel: "В ср. в день",
                    firstValue: metrics.averageCouponCountPerDay.formatted(),
                    secondLabel: "В ср. в неделю",
                    secondValue: metrics.averageCouponCountPerWeek.formatted())
                CuriousCard(
                    title: "Макс. серии дней",
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
                    title: "Самый длинный экспресс",
                    firstLabel: "Выигрышный",
                    firstValue: metrics.biggestWinningEventCount.formatted(),
                    secondLabel: "",
                    secondValue: "")
                CuriousCard(
                    title: "Самый частый вид спорта",
                    firstLabel: "Выигрышный",
                    firstValue: metrics.mostFrequencySport,
                    secondLabel: "",
                    secondValue: "")
            }
            .listRowInsets(.init())
            .listRowBackground(Color.clear)
        }
    }
    
    private func CuriousCard(
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

#Preview {
    let container = try! ModelContainer(for: Coupon.self, Event.self)
    ContentView()
        .modelContainer(container)
        .environment(CouponService(context: container.mainContext))
}
