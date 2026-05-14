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
            CuriousSectionView(metrics: HighlightsFactory.make(for: filtered))
        }
        .background(Color.lightMidnight)
        .toolbar { toolbarContent }
    }
}
