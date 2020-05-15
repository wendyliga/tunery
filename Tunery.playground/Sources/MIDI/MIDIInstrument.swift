//
//  Instrument.swift
//  Tunery
//
//  Created by Wendy Liga on 14/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

/**
 Use General Midi Standart for midi instrument
 
 https://en.wikipedia.org/wiki/General_MIDI#Parameter_interpretations
 */
enum MIDIInstrument: UInt8 {
    case grandPiano = 1
    case electricPiano = 5
    case celesta = 9
    case xylophone = 14
    case harmonica = 23
    case acousticGuitar = 25
    case electricGuitar = 28
    case acousticBass = 33
    case slapBass = 37
    case fluet = 74
}

extension MIDIInstrument: CaseIterable {
    var title: String {
        switch self {
        case .grandPiano:
            return "Grand Piano"
        case .electricPiano:
            return "Electric Piano"
        case .celesta:
            return "Celesta"
        case .xylophone:
            return "Xylophone"
        case .harmonica:
            return "Harmonica"
        case .acousticGuitar:
            return "Accoustic Guitar"
        case .electricGuitar:
            return "Electric Guitar"
        case .acousticBass:
            return "Acoustic Bass"
        case .slapBass:
            return "Slap Bass"
        case .fluet:
            return "Fluet"
        }
    }
}
