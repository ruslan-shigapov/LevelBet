//
//  EventSectionView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 25.02.2026.
//

import SwiftUI

struct EventSectionView: View {
    
    @Binding var isModalViewPresented: Bool
    @Binding var events: [Event]
    
    var body: some View {
        Section {
            AddButton()
            EventList()
        } header: {
            SectionHeader()
        } footer: {
            SectionFooter()
        }
    }
}

private extension EventSectionView {
    
    func AddButton() -> some View {
        Button("Добавить") {
            isModalViewPresented = true
        }
    }
    
    func EventList() -> some View {
        List {
            ForEach($events) { $event in
                HStack(spacing: Layouts.standardOffset) {
                    StatusPicker($event.status)
                    LabeledContent(event.sport.rawValue) {
                        Text(event.odds.formatted())
                            .monospaced()
                    }
                    .foregroundStyle(.secondary)
                }
                .swipeActions(edge: .trailing) {
                    DeleteSwipeButton {
                        if let index = events.firstIndex(
                            where: { $0 == event }
                        ) {
                            events.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    func StatusPicker(_ selection: Binding<Statuses>) -> some View {
        Picker("", selection: selection) {
            ForEach(Statuses.allCases.dropFirst()) {
                Image(systemName: $0.imageName)
            }
        }
        .pickerStyle(.segmented)
    }
    
    func SectionHeader() -> some View {
        LabeledContent("События", value: String(events.count))
            .fontWeight(.semibold)
    }
    
    func SectionFooter() -> some View {
        Text(
            events.count > 0
            ? "Потяните влево, чтобы удалить событие."
            : "Купон должен содержать хотя бы одно событие.")
    }
}
