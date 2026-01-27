//
//  ToolbarButton.swift
//  LevelBet
//
//  Created by Ruslan Shigapov on 27.01.2026.
//

import SwiftUI

struct ToolbarButton: View {
    
    enum ToolbarButtonType {
        case add, cancel, done
        
        var imageName: String {
            switch self {
            case .add: "plus"
            case .cancel: "xmark"
            case .done: "checkmark"
            }
        }
    }
    
    let type: ToolbarButtonType
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: type.imageName)
        }
    }
}
