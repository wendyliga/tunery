//
//  MIDINote.swift
//  Tunery
//
//  Created by Wendy Liga on 13/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

protocol Sequencerable {
    var time: TimeInterval { get }
    var volume: Float { get }
}

/**
 with General MIDI standart
 
 source https://en.wikipedia.org/wiki/General_MIDI
 */
struct MIDINote: Sequencerable {
    let note: UInt8
    let velocity: UInt8
    let channel: UInt8
    
    // not included in MIDI Standart, but add it so MIDINote can be sequenceable on MIDISequencer.
    var time: TimeInterval
    var volume: Float
}

extension MIDINote {
    static var zero: MIDINote {
        .init(note: .zero, velocity: .zero, channel: .zero, time: .zero, volume: .zero)
    }
}
