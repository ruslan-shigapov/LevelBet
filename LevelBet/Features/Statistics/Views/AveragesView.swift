//
//  AveragesView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 19.03.2026.
//

import SwiftUI

struct AveragesView: View {
    
    @State private var isExpanded = false
    
    let title: String
    let overall: String
    let won: String
    let lost: String
    
    var body: some View {
        VStack(spacing: Layouts.smallOffset) {
            HStack {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .imageScale(.small)
                    .foregroundStyle(.secondary)
                LabeledContent(title, value: overall)
            }
            if isExpanded {
                VStack {
                    LabeledContent {
                        Text(won)
                            .foregroundStyle(.green)
                    } label: {
                        Text("Выигранные")
                            .foregroundStyle(.secondary)
                    }
                    LabeledContent {
                        Text(lost)
                            .foregroundStyle(.pink)
                    } label: {
                        Text("Проигранные")
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.footnote)
            }
        }
        .contentShape(.rect)
        .onTapGesture {
            withAnimation(.snappy) {
                isExpanded.toggle()
            }
        }
    }
}
