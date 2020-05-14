//
//  Key.swift
//  wwdc2020
//
//  Created by Wendy Liga on 07/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

/**
 Representing Key on music, each key will have its rawValue that represent the grade level of each key, the higher the grade, the higher the key position on music key.
 */
enum Key: Int {
    case none = -1
    case C = 1
    case D = 3
    case E = 5
    case F = 6
    case G = 8
    case A = 10
    case B = 12
    
    /**
     Representing key in String Format
     */
    var symbol: String {
        switch self {
        case .none:
            return "-"
        case .A:
            return "A"
        case .B:
            return "B"
        case .C:
            return "C"
        case .D:
            return "D"
        case .E:
            return "E"
        case .F:
            return "F"
        case .G:
            return "G"
        }
    }
}

extension Key: Codable {}

extension Key: CaseIterable {}

extension Key {
    static var highest: Key {
        .B
    }
    
    static var lowest: Key {
        .none
    }
}

extension Key {
    func transpose(_ direction: Transpose) -> Key {
        switch direction {
        case .up:
            for key in Key.allCases where key > self {
                if key > self {
                    return key
                }
            }
        case .down:
            for key in Key.allCases.reversed() {
                if key < self {
                    return key
                }
            }
        }
        
        return self
    }
}

func >(_ lhs: Key, _ rhs: Key) -> Bool {
    lhs.rawValue > rhs.rawValue
}

func >=(_ lhs: Key, _ rhs: Key) -> Bool {
    lhs.rawValue >= rhs.rawValue
}

func <(_ lhs: Key, _ rhs: Key) -> Bool {
    lhs.rawValue < rhs.rawValue
}

func <=(_ lhs: Key, _ rhs: Key) -> Bool {
    lhs.rawValue <= rhs.rawValue
}
