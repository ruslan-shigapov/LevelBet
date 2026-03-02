//
//  ResultsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI
import SwiftData

struct ResultsView: View {
    
    @State private var selectedPeriod = Periods.week
    @State private var isModalViewPresented = false
    @State private var selectedStatus = Statuses.all
    @State private var selectedCoupon: Coupon?
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            EditButton()
        }
        ToolbarItemGroup {
            FilterMenu(selectedPeriod: $selectedPeriod)
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
        .background(Color.lightMidnight)
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

#Preview {
    let container = try! ModelContainer(for: Coupon.self, Event.self)
    ContentView()
        .modelContainer(container)
        .environment(CouponService(context: container.mainContext))
}
