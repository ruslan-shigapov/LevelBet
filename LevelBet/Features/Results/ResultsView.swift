//
//  ResultsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import SwiftData

struct ResultsView: View {
    
    @State private var isModalViewPresented = false
    @State private var selectedPeriod = Periods.week
    @State private var selectedStatus = Statuses.all
    @State private var selectedCoupon: Coupon?
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            EditButton()
        }
        ToolbarItemGroup {
            FilterMenu()
            ToolbarButton(type: .add) {
                isModalViewPresented = true
            }
        }
    }

    var body: some View {
        VStack {
            StatusBarView(selectedStatus: $selectedStatus)
            CouponListView(selectedCoupon: $selectedCoupon)
        }
        .toolbarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .fullScreenCover(isPresented: $isModalViewPresented) {
            CouponEditorView()
        }
        .fullScreenCover(item: $selectedCoupon) {
            CouponEditorView(coupon: $0)
        }
    }
}

private extension ResultsView {
    
    func FilterMenu() -> some View {
        Menu {
            Text("Период:")
            Divider()
            ForEach(Periods.allCases) { period in
                Button {
                    selectedPeriod = period
                } label: {
                    if selectedPeriod == period {
                        Label(period.rawValue, systemImage: "checkmark")
                    } else {
                        Text(period.rawValue)
                    }
                }
            }
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
        }
    }
}

#Preview {
    let container = try! ModelContainer(for: Coupon.self, Event.self)
    ContentView()
        .modelContainer(container)
        .environment(CouponService(context: container.mainContext))
}
