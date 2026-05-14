//
//  InfoView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 14.05.2026.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem {
            ToolbarButton(type: .cancel) {
                dismiss()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                InfoCard(title: "Профит", text: "Чистая прибыль")
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.midnight)
            .navigationTitle("Справка")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .presentationDragIndicator(.visible)
    }
    
    private func InfoCard(title: String, text: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            Text(text)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

#Preview {
    InfoView()
}
