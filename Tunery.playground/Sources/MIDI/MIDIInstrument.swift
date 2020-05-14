//
//  Instrument.swift
//  wwdc2020
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
    case guitar = 25
}

extension MIDIInstrument: CaseIterable {
    var title: String {
        switch self {
        case .grandPiano:
            return "Grand Piano"
        case .guitar:
            return "Guitar"
        }
    }
}
