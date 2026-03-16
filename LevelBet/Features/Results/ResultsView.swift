//
//  ResultsView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.01.2026.
//

import SwiftUI

struct ResultsView: View {
        
    @State private var selectedPeriod = Periods.week
    @State private var isModalViewPresented = false
    @State private var selectedCoupon: Coupon?
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            FilterMenu(selectedPeriod: $selectedPeriod)
        }
        ToolbarItem {
            ToolbarButton(type: .add) {
                isModalViewPresented = true
            }
        }
    }

    var body: some View {
        CouponListView(
            selectedPeriod: selectedPeriod,
            selectedCoupon: $selectedCoupon)
        .background(Color.lightMidnight)
        .toolbar { toolbarContent }
        .fullScreenCover(isPresented: $isModalViewPresented) {
            CouponEditorView()
        }
        .fullScreenCover(item: $selectedCoupon) {
            CouponEditorView(coupon: $0)
        }
    }
}
