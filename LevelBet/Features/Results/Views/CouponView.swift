//
//  CouponView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI
import SwiftData

// TODO: refactor with separate logic and UI consistence 
struct CouponView: View {
    
    let coupon: Coupon
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Text("Ординар")
                    .font(.footnote.bold())
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(.blue)
                    .clipShape(Capsule())
                Spacer()
                Image(systemName: coupon.totalStatus.imageName)
                    .font(.title3)
                    .foregroundStyle(coupon.totalStatus.color)
            }
            HStack {
                Text(coupon.stake.description)
                Text("x 2,00")
                    .foregroundStyle(.blue)
                Spacer()
                Text("2000")
                    .foregroundStyle(coupon.totalStatus.color)
            }
        }
        .contentShape(.rect)
    }
}

#Preview {
    let container = try! ModelContainer(for: Coupon.self, Event.self)
    ContentView()
        .modelContainer(container)
        .environment(CouponService(context: container.mainContext))
}
