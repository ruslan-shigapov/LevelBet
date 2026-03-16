//
//  StatusBarView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI

struct StatusBarView: View {
    
    @Binding var selectedStatus: Statuses
    
    var body: some View {
        HStack {
            ForEach(Statuses.allCases.filter { $0 != .all }) {
                ResizableButton(status: $0)
            }
            if selectedStatus == .all {
            }
            ResizableButton(status: .all)
                .frame(width: selectedStatus == .all ? nil : 0)
                .opacity(selectedStatus == .all ? 1 : 0)
                .scaleEffect(selectedStatus == .all ? 1 : 0.9)
                .allowsHitTesting(selectedStatus == .all)
        }
        .frame(height: 50)
        .padding(.top, Layouts.smallOffset)
    }
}

private extension StatusBarView {
    
    func ResizableButton(status: Statuses) -> some View {
        HStack {
            Image(systemName: status.imageName)
                .font(.title3)
                .symbolVariant(selectedStatus == status ? .fill : .none)
            if selectedStatus == status {
                Text(status.rawValue)
                    .font(.callout.weight(.semibold))
                    .lineLimit(1)
            }
        }
        .foregroundStyle(selectedStatus == status ? .primary : .secondary)
        .frame(
            maxWidth: selectedStatus == status ? .infinity : nil,
            maxHeight: .infinity)
        .padding(.horizontal)
        .background(selectedStatus == status ? status.color : .secondary)
        .clipShape(.capsule)
        .onTapGesture {
            guard status != .all else { return }
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation(.snappy) {
                if selectedStatus == status {
                    selectedStatus = .all
                } else {
                    selectedStatus = status
                }
            }
        }
    }
}
