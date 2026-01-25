//
//  LoadingView.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 25/01/2026.
//

import SwiftUI

struct LoadingView: View {
    let text: String
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.white)
                
                Text(text)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .edgesIgnoringSafeArea(.all)
        .background(Color.black.opacity(0.5))
    }
}

#Preview {
    LoadingView(text: "Loading...")
}
