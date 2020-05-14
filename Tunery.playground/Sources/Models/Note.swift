//
//  Note.swift
//  wwdc2020
//
//  Created by Wendy Liga on 07/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

struct Note {
    var key: Key
    
    /**
     Determining octave, default 4
     */
    var octave: Int
    
    /**
     Color
     */
    var color: UIColor?
    
    init(key: Key, octave: Int = 4, color: UIColor?) {
        self.key = key
        self.octave = octave
        self.color = color
    }
}

extension Note: Equatable {}

extension Note: Codable {
    enum CodingKeys: String, CodingKey {
        case key
        case octave
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        key = try container.decode(Key.self, forKey: .key)
        octave = try container.decode(Int.self, forKey: .octave)
        color = nil
    }
    
    func encode(to encoder: Encoder) throws {
        var encoder = encoder.container(keyedBy: CodingKeys.self)
        
        try encoder.encode(key, forKey: .key)
        try encoder.encode(octave, forKey: .octave)
    }
}

extension Note {
    static var C: Note {
        Note(key: .C, octave: 4, color: .from(key: .C, octave: 4))
    }
    
    static var D: Note {
        Note(key: .D, octave: 4, color: .from(key: .D, octave: 4))
    }
    
    static var E: Note {
        Note(key: .E, octave: 4, color: .from(key: .E, octave: 4))
    }
    
    static var F: Note {
        Note(key: .F, octave: 4, color: .from(key: .F, octave: 4))
    }
    
    static var G: Note {
        Note(key: .G, octave: 4, color: .from(key: .G, octave: 4))
    }
    
    static var A: Note {
        Note(key: .A, octave: 4, color: .from(key: .A, octave: 4))
    }
    
    static var B: Note {
        Note(key: .B, octave: 4, color: .from(key: .B, octave: 4))
    }
    
    static var none: Note {
        Note(key: .none, octave: 4, color: .from(key: .none, octave: 4))
    }
}

extension Note {
    mutating func transpose(_ direction: Transpose) {
        let boundsKey: () -> Key = {
            direction == .up ? .highest : .lowest
        }
        
        // check if current key is same with bounds value, mean octave operations needed
        // for default below octave 4
        guard self.key.rawValue != boundsKey().rawValue else {
            if octave == 4 {
                let newKey: Key = direction == .up ? .C : .lowest
                let newOctave: Int = direction == .up ? self.octave + 1 : self.octave - 1
                
                self.key = newKey
                self.octave = newOctave
                self.color = .from(key: newKey, octave: newOctave)
            } else if octave > 4 {
                let newKey: Key = direction == .up ? .C : .B
                let newOctave: Int = direction == .up ? self.octave + 1 : self.octave - 1
                
                self.key = newKey
                self.octave = newOctave
                self.color = .from(key: newKey, octave: newOctave)
            }
            
            return
        }
        
        // if not same with bounds, then do default transpose
        let newKey = self.key.transpose(direction)
        
        self.key = newKey
        self.color = .from(key: newKey, octave: self.octave)
    }
    
    mutating func transpose(_ transpose: Transpose, count: Int) {
        guard count > 0 else { return }
        
        (0 ..< count).forEach { _ in
            self.transpose(transpose)
        }
    }
    
    func numberOftranspose(to note: Note) -> Int {
        let direction: Transpose = self.frequency > note.frequency ? .down : .up
        
        
        if octave == note.octave && direction == .down {
            var counter = Int.init()
            
            Key.allCases.forEach { key in
                if key < self.key && key >= note.key {
                    counter += 1
                }
            }
            
            return counter * -1
        }
        
        if octave == note.octave && direction == .up {
            var counter = Int.init()
            
            Key.allCases.forEach { key in
                if key > self.key && key <= note.key {
                    counter += 1
                }
            }
            
            return counter * 1
        }
        
        // when octave is different
        let octaveDifferenciesCounter = abs(octave - note.octave) * 7
        let newNoteOnSameOctave = Note(key: note.key, octave: octave, color: nil)
        
        return (octaveDifferenciesCounter + numberOftranspose(to: newNoteOnSameOctave)) * (direction == .up ? 1 : -1)
    }
}

extension Note {
    var MIDINote: UInt8 {
        guard key != .none else { return .zero }
        
        /// representing key number in piano
        ///
        /// +3 as constant of first C (4), an C rawValue is 1
        return UInt8(key.rawValue + 3 + ((octave - 1) * 12))
    }
    
    /**
     Get Note Frequency
     */
    var frequency: Float {
        guard key != .none else { return .zero }
        
        /// calculating frequency based on key number
        ///
        /// source: https://en.wikipedia.org/wiki/Piano_key_frequencies
        let frequency: Float = pow(2.0, ((Float(MIDINote) - 49.0) / 12.0)) * 440.0
        
        return frequency
    }
}

extension Array where Element == Note {
    func MIDIs(duration: TimeInterval) -> [MIDINote] {
        var midis = [MIDINote]()

        zip(self.indices, self).forEach({ (index, value) in
            guard value.key != .none else {
                midis.append(
                    MIDINote(note: 120, velocity: 0, channel: 0, time: duration, volume: 0)
                )

                return
            }

            midis.append(.init(note: value.MIDINote, velocity: 120, channel: 0, time: duration, volume: 0.8))
        })

        return midis
    }
    
    func dividedTo(_ count: Int, filler: Element) -> [[Element]] {
        var results = [[Element]]()
        var temp = [Element]()
        var counter = 0
        
        let flush: () -> Void = {
            results.append(temp)
            temp.removeAll()
        }
        
        zip(self.indices, self).forEach { (index, value) in
            guard counter < count else {
                flush()
                
                // start again
                temp.append(value)
                counter = 1
                
                return
            }
            
            temp.append(value)
            counter += 1
        }
        
        flush()
        
        zip(results.indices, results).forEach { (index, value) in
            let different = count - value.count

            if different > 0 {
                let filler = (0..<different).map { _ in filler }
                results[index].append(contentsOf: filler)
            }
        }
        
        return results
    }
}
