//
//  Trie.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 22/01/2026.
//

/// A node in a Trie (prefix tree) data structure.
///
/// `TrieNode` represents a single character in the Trie and holds:
/// - A dictionary of child nodes keyed by their corresponding character
/// - A collection of values associated with the path ending at this node
///
/// - Note: This implementation is generic, allowing any value type to be
///   associated with a given prefix.
final class TrieNode<T> {
    
    /// Child nodes indexed by character.
    ///
    /// Each key represents the next character in the prefix,
    /// and the value is the corresponding `TrieNode`.
    var children: [Character: TrieNode<T>] = [:]
    
    /// Values associated with the prefix represented by this node.
    ///
    /// This array typically contains all values that fully match
    /// the prefix up to this node.
    var values: [T] = []
}

/// Defines the interface for a Trie (prefix tree).
///
/// `TrieProtocol` exposes the minimum functionality required to
/// perform prefix-based searches and manage the stored data,
/// while hiding the underlying implementation details.
protocol TrieProtocol {
    
    /// The type of values stored in the Trie.
    associatedtype Value
    
    /// Searches for values matching the given prefix.
    ///
    /// - Parameter prefix: The prefix to search for.
    /// - Returns: An array of values whose keys start with the given prefix.
    ///
    /// - Note: Implementations are expected to perform this operation
    ///   efficiently, leveraging the Trie structure.
    func search(prefix: String) -> [Value]
    
    /// Removes all stored values from the Trie.
    ///
    /// After calling this method, the Trie should be empty
    /// and ready to be reused.
    func removeAll()
}

final class Trie<T>: TrieProtocol {
    // MARK: - Private properties
    typealias Value = T
    private let root = TrieNode<T>()
    
    // MARK: - TrieProtocol methods
    func insert(key: String, value: T) {
        var node = root
        
        for char in key.lowercased() {
            if let child = node.children[char] {
                node = child
            } else {
                let newNode = TrieNode<T>()
                node.children[char] = newNode
                node = newNode
            }
        }
        node.values.append(value)
    }
    
    func search(prefix: String) -> [T] {
        guard !prefix.isEmpty else { return [] }
        
        var node = root
        
        for char in prefix.lowercased() {
            guard let next = node.children[char] else {
                return []
            }
            node = next
        }
        return collectValues(from: node)
    }
    
    func removeAll() {
        root.children.removeAll()
        root.values.removeAll()
    }
    
    // MARK: - Private methods
    private func collectValues(from node: TrieNode<T>) -> [T] {
        var result = node.values
        for child in node.children.values {
            result.append(contentsOf: collectValues(from: child))
        }
        return result
    }
}
