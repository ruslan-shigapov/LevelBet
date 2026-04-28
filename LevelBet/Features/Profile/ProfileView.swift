//
//  ProfileView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import SwiftData

struct ProfileView: View {
        
    @Query(sort: \Coupon.timestamp) private var coupons: [Coupon]
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gear")
            }
        }
    }
    
    private var filtered: [Coupon] {
        coupons.filter {
            FilterFactory.matches(coupon: $0, period: .year)
        }
    }
    
    var body: some View {
        List {
            Section("Банк") {}
            CuriousSection(metrics: HighlightsFactory.make(for: filtered))
        }
        .background(Color.lightMidnight)
        .toolbar { toolbarContent }
    }
    
    private func CuriousSection(metrics: Highlights) -> some View {
        Section("Любопытное") {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())]
            ) {
                CuriousCard(
                    title: "Макс. результаты",
                    firstLabel: "Чист. выигр.",
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
                    firstValue: metrics.biggestWinningOdds.oddsFormatted,
                    secondLabel: "Мин. проигр.",
                    secondValue: metrics.smallestLosingOdds.oddsFormatted)
                CuriousCard(
                    title: "Коэф. событий",
                    firstLabel: "Макс. выигр.",
                    firstValue: metrics.biggestWinningEventOdds.oddsFormatted,
                    secondLabel: "Мин. проигр.",
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
