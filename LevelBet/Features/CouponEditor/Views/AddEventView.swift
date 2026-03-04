//
//  AddEventView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 24.02.2026.
//

import SwiftUI

struct AddEventView: View {
        
    // MARK: Private Properties
    @Environment(\.dismiss) private var dismiss

    @FocusState private var isFocused: Bool
    
    @State private var selectedSport: Sports = .football
    @State private var odds: String = ""
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            ToolbarButton(type: .cancel) {
                dismiss()
            }
        }
        ToolbarItem {
            ToolbarButton(type: .done) {
                addEvent()
                dismiss()
            }
            .disabled(!isValid)
        }
    }
    
    private var formatted: Double? {
        Double(odds.replacingOccurrences(of: ",", with: "."))
    }
    
    private var isValid: Bool {
        formatted != nil && (formatted ?? 0) > 1
    }
    
    // MARK: Public Properties
    let onAdd: (Event) -> Void
    
    // MARK: Body
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    SportPicker()
                    LabeledTextField()
                } footer: {
                    SectionFooter()
                }
            }
            .navigationTitle("Новое событие")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .onAppear {
            isFocused = true
        }
    }
    
    // MARK: Private Methods 
    private func addEvent() {
        let event = Event(sport: selectedSport, odds: formatted ?? 0)
        onAdd(event)
    }

    private func sanitize(input: String, previous: String) -> String {
        let filtered = input.filter { $0.isNumber || $0 == "," }
        let normalized = filtered.hasPrefix(",") ? "0" + filtered : filtered
        if !normalized.contains(",") {
            while normalized.count > 1 && normalized.hasPrefix("0") {
                return previous
            }
        }
        let parts = normalized.split(
            separator: ",",
            omittingEmptySubsequences: false)
        if parts.count > 2 {
            return previous
        }
        if parts.count == 2 {
            let firstPart = parts[0]
            let secondPart = parts[1].prefix(2)
            return "\(firstPart),\(secondPart)"
        }
        return String(normalized.prefix(4))
    }
}

// MARK: - Views
private extension AddEventView {
    
    func SportPicker() -> some View {
        Picker("Вид спорта", selection: $selectedSport) {
            ForEach(Sports.allCases) {
                Text($0.rawValue)
            }
        }
    }
    
    func LabeledTextField() -> some View {
        LabeledContent {
            TextField("0", text: $odds)
                .monospaced()
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.trailing)
                .focused($isFocused)
                .onChange(of: odds) {
                    odds = sanitize(input: $1, previous: $0)
                }
        } label: {
            Text("Коэффициент")
                .foregroundStyle(!isValid ? .secondary : .primary)
        }
    }
    
    func SectionFooter() -> some View {
        Text("Значение должно быть больше единицы.")
            .opacity((formatted ?? 0) <= 1 ? 1 : 0)
    }
}
