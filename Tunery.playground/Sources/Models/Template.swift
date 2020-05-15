//
//  Template.swift
//  Tunery
//
//  Created by Wendy Liga on 13/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

enum Template {
    case `default`
    case jingleBell
    case twingkleStar
    case doremi
}

extension Template: CaseIterable {
    var title: String {
        switch self {
        case .default:
            return "Default"
        case .jingleBell:
            return "Jingle Bell"
        case .twingkleStar:
            return "Twingkle Twingkle Little Star"
        case .doremi:
            return "do-re-mi"
        }
    }
    
    var notes: [Note] {
        switch self {
        case .default:
            return [
                .C, .D, .E, .F, .G, .A, .B, Note(key: .C, octave: 5, color: nil), Note(key: .D, octave: 5, color: nil), Note(key: .E, octave: 5, color: nil)
            ]
        case .jingleBell:
            return [
                .E, .E, .E, .none, .E, .E, .E, .none,
                .E, .G, .C, .D, .E, .none, .none, .none,
                .F, .F, .F, .none, .F, .E, .E, .none,
                .E, .D, .D, .E, .D, .none, .G, .none,
                
                .E, .E, .E, .none, .E, .E, .E, .none,
                .E, .G, .C, .D, .E, .none, .none, .none,
                .F, .F, .F, .none, .F, .E, .E, .none,
                .G, .G, .E, .D, .C, .none, .none,
            ]
        case .twingkleStar:
            return [
                .C, .C, .G, .G, .A, .A, .G, .none,
                .F, .F, .E, .E, .D, .D , .C, .none,
                .G, .G, .F, .F, .E, .E , .D, .none,
                .G, .G, .F, .F, .E, .E, .D, .none,
                .C, .C, .G, .G, .A, .A, .G, .none,
                .F, .F, .E, .E, .D, .D, .C
            ]
        case .doremi:
            return [
                .C, .none, .D, .E, .none, .C, .E, .none, .C, .none, .E, .none, .none,
                .D, .none, .E, .F, .F, .E, .D, .F, .none, .none, .none,
                .E, .none, .F, .G, .none, .E, .G, .none, .E, .G, .none, .none,
                .F, .none, .G, .A, .A, .G, .F, .A, .none, .none, .none,
                .G, .none, .C, .D, .E, .F, .G, .A, .none, .none, .none,
                .A, .none, .D, .E, .F, .G, .A, .B, .none, .none, .none,
                .B, .none, .E, .F, .G, .A, .B, Note(key: .C, octave: 5, color: nil), .none, .none, .none,
                Note(key: .C, octave: 5, color: nil), .B, .A, .none , .F, .none, .B, .none , .G, .none, Note(key: .C, octave: 5, color: nil), .none,
                .C, .D, .E, .F, .G, .A, .B, Note(key: .C, octave: 5, color: nil), .none, .none,
                .G, Note(key: .C, octave: 5, color: nil)
            ]
        }
    }
    
    var bpm: Int {
        switch self {
        case .default:
            return 120
        case .jingleBell:
            return 175
        case .twingkleStar:
            return 160
        case .doremi:
            return 165
        }
    }
}
