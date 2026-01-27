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
                ResizableButton(status: .all)
                    .transition(.offset(x: 200))
            }
        }
        .frame(height: 50)
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    func ResizableButton(status: Statuses) -> some View {
        HStack {
            Image(systemName: status.imageName)
                .font(.title3)
                .symbolVariant(selectedStatus == status ? .fill : .none)
            if selectedStatus == status {
                Text(status.rawValue)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
            }
        }
        .foregroundStyle(selectedStatus == status ? .primary : .secondary)
        .frame(
            maxWidth: selectedStatus == status ? .infinity : nil,
            maxHeight: .infinity)
        .padding(.horizontal)
        .background {
            Rectangle()
                .fill(selectedStatus == status ? status.color : .secondary)
        }
        .clipShape(.rect(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            guard status != .all else { return }
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
            withAnimation(.bouncy) {
                if selectedStatus == status {
                    selectedStatus = .all
                } else {
                    selectedStatus = status
                }
            }
        }
    }
}
