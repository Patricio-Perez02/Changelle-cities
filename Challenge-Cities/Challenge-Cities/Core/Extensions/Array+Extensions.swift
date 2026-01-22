//
//  Array+Extensions.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 22/01/2026.
//

import Foundation

extension Array {
    func sortedAlphabetically(
        by keyPath: KeyPath<Element, String>
    ) -> [Element] {
        sorted {
            $0[keyPath: keyPath]
                .localizedCaseInsensitiveCompare($1[keyPath: keyPath]) == .orderedAscending
        }
    }
}
