//
//  CouponView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI
import SwiftData

struct CouponView: View {
    
    let coupon: Coupon
    
    var body: some View {
        VStack(spacing: Layouts.mediumOffset) {
            HStack {
                TypeText()
                Spacer()
                StatusImage()
            }
            HStack {
                Text(coupon.stake.formatted())
                Text("x ")
                    .foregroundStyle(.blue)
                Spacer()
                Text("2000")
                    .foregroundStyle(coupon.totalStatus.color)
            }
        }
        .contentShape(.rect)
    }
}

private extension CouponView {
    
    func TypeText() -> some View {
        Text(coupon.events.count == 1 ? "Одинар" : "Экспресс")
            .font(.footnote.bold())
            .padding(.vertical, Layouts.tinyOffset)
            .padding(.horizontal, Layouts.smallOffset)
            .background(Capsule().fill(Color.accentColor))
    }
    
    func StatusImage() -> some View {
        Image(systemName: coupon.totalStatus.imageName)
            .font(.title3)
            .foregroundStyle(coupon.totalStatus.color)
    }
}

#Preview {
    let container = try! ModelContainer(for: Coupon.self, Event.self)
    ContentView()
        .modelContainer(container)
        .environment(CouponService(context: container.mainContext))
}
