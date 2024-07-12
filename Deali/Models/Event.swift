//
//  Event.swift
//  Deali
//
//  Created by Kirill Pukhov on 12.07.24.
//

import Foundation

enum EventType {
    case cellCreation(Cell)
    case lifeBirth(Life)
    case lifeDeath(Life)
}

extension EventType: Hashable {}

struct Event: Identifiable {
    let id = UUID()
    let timestamp = Date()
    let type: EventType
}

extension Event: Hashable {}
