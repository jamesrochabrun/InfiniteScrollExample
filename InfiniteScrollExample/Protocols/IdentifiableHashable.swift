//
//  IdentifiableHashable.swift
//  InfiniteScrollExample
//
//  Created by James Rochabrun on 4/19/21.
//

import Foundation


/// Protocol composition with an extension to provide `Hashable` conformance to an object.
/// This is mostly for SwiftUI objects, but it can also be used in a DiffableCollection View
protocol IdentifiableHashable: Hashable & Identifiable {}
extension IdentifiableHashable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id) }
}
