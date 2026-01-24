//
//  Array+Extensions.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 22/01/2026.
//

import Foundation

extension Array {
    /// Returns the elements of the collection sorted alphabetically
    /// using a case-insensitive, locale-aware comparison.
    ///
    /// This method compares the `String` values referenced by the given
    /// key path using `localizedCaseInsensitiveCompare(_:)`, making it
    /// suitable for user-facing text.
    ///
    /// - Parameter keyPath: A key path to the `String` property used
    ///   for sorting.
    /// - Returns: A new array containing the elements sorted in
    func sortedAlphabetically(
        by keyPath: KeyPath<Element, String>
    ) -> [Element] {
        sorted {
            $0[keyPath: keyPath]
                .localizedCaseInsensitiveCompare($1[keyPath: keyPath]) == .orderedAscending
        }
    }
}
