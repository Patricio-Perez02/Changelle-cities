//
//  InfoRow.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

import SwiftUI

struct InfoRow: View {
    let icon: Image
    let title: String
    let value: String
    let foregroundColor: Color = .white
    
    var body: some View {
        HStack(spacing: 12) {
            icon
                .font(.system(size: 20, weight: .semibold))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.footnote)

                Text(value)
                    .font(.body.weight(.semibold))
            }

            Spacer()
        }
        .foregroundStyle(foregroundColor)
        .padding(12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(value)")
    }
}
