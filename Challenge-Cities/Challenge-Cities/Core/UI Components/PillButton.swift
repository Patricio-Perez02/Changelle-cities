//
//  PillButton.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 22/01/2026.
//

import SwiftUI

struct PillButton: View {
    var image: Image? = nil
    var title: String? = nil
    let action: () -> Void
    
    init(
        image: Image? = nil,
        title: String? = nil,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.title = title
        self.action = action
    }
    
    var isIconOnly: Bool {
        return image != nil && title == nil
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let image {
                    image
                        .font(.system(size: 14, weight: .medium))
                }

                if let title {
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                }
            }
            .padding(isIconOnly ? 10 : 16)
            .frame(minHeight: 32)
            .background(.ultraThinMaterial)
            .clipShape(
                isIconOnly ? AnyShape(Circle()) : AnyShape(Capsule())
            )
            .shadow(radius: 10)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack {
        PillButton(
            image: Image(systemName: "heart"),
            title: "Favorites",
            action: {}
        )
        
        PillButton(
            title: "Favorites",
            action: {}
        )
        
        PillButton(
            image: Image(systemName: "heart"),
            action: {}
        )
    }
}
