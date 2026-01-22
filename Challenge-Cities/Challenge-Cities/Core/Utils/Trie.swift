//
//  Trie.swift
//  Challenge-Cities
//
//  Created by Patricio Perez on 22/01/2026.
//

final class TrieNode<T> {
    var children: [Character: TrieNode<T>] = [:]
    var values: [T] = []
}

protocol TrieProtocol {
    associatedtype Value
    func search(prefix: String) -> [Value]
}

final class Trie<T>: TrieProtocol {
    typealias Value = T
    private let root = TrieNode<T>()
    
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
    
    private func collectValues(from node: TrieNode<T>) -> [T] {
        var result = node.values
        for child in node.children.values {
            result.append(contentsOf: collectValues(from: child))
        }
        return result
    }
}
