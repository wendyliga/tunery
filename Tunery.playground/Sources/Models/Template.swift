//
//  Template.swift
//  wwdc2020
//
//  Created by Wendy Liga on 13/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

enum Template {
    case `default`
    case jingleBell
}

extension Template: CaseIterable {
    var title: String {
        switch self {
        case .default:
            return "Default"
        case .jingleBell:
            return "Jingle Bell"
        }
    }
    
    var notes: [Note] {
        switch self {
        case .default:
            return [
                .C, .D, .E, .F, .G, .A, .B, Note(key: .C, octave: 5, color: nil)
            ]
        case .jingleBell:
            return [
                .E, .E, .E, .none, .E, .E, .E, .none,
                .E, .G, .C, .D, .E, .none, .none, .none,
                .F, .F, .F, .none, .F, .E, .E, .none,
                .E, .D, .D, .E, .D, .none, .G, .none, .none,
                
                .E, .E, .E, .none, .E, .E, .E, .none,
                .E, .G, .C, .D, .E, .none, .none, .none,
                .F, .F, .F, .none, .F, .E, .E, .none,
                .G, .G, .E, .D, .C, .none, .none
            ]
        }
    }
    
    var bpm: Int {
        switch self {
        case .default:
            return 120
        case .jingleBell:
            return 175
        }
    }
}
