//
//  String+Extensions.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 31/01/2026.
//

import Foundation

extension String {
    func normalized() -> String {
        folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
