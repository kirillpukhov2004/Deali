//
//  Life.swift
//  Deali
//
//  Created by Kirill Pukhov on 12.07.24.
//

import Foundation

enum LifeState {
    case alive
    case dead
}

extension LifeState: Hashable {}

struct Cell: Identifiable {
    let id = UUID()
    let state: LifeState
}

extension Cell: Hashable {}

struct Life: Identifiable {
    let id = UUID()
    var state: LifeState = .alive
}

extension Life: Hashable {}
