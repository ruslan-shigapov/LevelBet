//
//  MainSectionView.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 25.02.2026.
//

import SwiftUI

struct MainSectionView: View {
    
    @FocusState private var isFocused: Bool
    
    private var isValid: Bool {
        !stake.isEmpty && stake != "0"
    }
    
    @Binding var stake: String
    
    let totalOdds: Double
    let totalStatus: Statuses
    
    var body: some View {
        Section {
            LabeledStakeTextField()
            LabeledTotalOdds()
            LabeledWinnings()
        }
    }
    
    private func sanitize(input: String) -> String {
        let filtered = String(input.filter(\.isNumber).prefix(8))
        return formatWithSpaces(filtered)
    }
    
    private func formatWithSpaces(_ string: String) -> String {
        guard let number = Int(string) else { return "" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: number)) ?? string
    }
    
    private func calculateWinnings() -> Double {
        (Double(stake.replacingOccurrences(of: " ", with: "")) ?? 0) * totalOdds
    }
}

private extension MainSectionView {
    
    func LabeledStakeTextField() -> some View {
        LabeledContent {
            HStack {
                DoneButton()
                    .opacity(isFocused && isValid ? 1 : 0)
                TextField("0", text: $stake)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                    .focused($isFocused)
                    .onChange(of: stake) {
                        stake = sanitize(input: $1)
                    }
            }
        } label: {
            Text("Сумма")
                .foregroundStyle(!isValid ? .secondary : .primary)
        }
    }
    
    func DoneButton() -> some View {
        Button {
            isFocused = false
        } label: {
            Text("Готово")
                .font(.footnote.weight(.medium))
                .padding(.horizontal, Layouts.smallOffset)
                .padding(.vertical, Layouts.tinyOffset)
        }
        .background(Capsule().fill(.white))
        .padding(.horizontal, Layouts.smallOffset)
    }
    
    func LabeledTotalOdds() -> some View {
        LabeledContent("Общий коэффициент") {
            Text(
                totalOdds.formatted(
                    .number.precision(.fractionLength(0...2))))
            .frame(width: 140, alignment: .trailing)
            .lineLimit(1)
        }
    }
    
    func LabeledWinnings() -> some View {
        LabeledContent(
            "В" + (totalStatus == .pending ? "озможный в" : "") + "ыигрыш"
        ) {
            Text(
                totalStatus != .lost ?
                Int(calculateWinnings()).formatted()
                : "0")
            .frame(width: 140, alignment: .trailing)
            .lineLimit(1)
        }
    }
}
