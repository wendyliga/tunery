//
//  MIDISequencer.swift
//  wwdc2020
//
//  Created by Wendy Liga on 13/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

final class MIDISequencer {
    // MARK: - Interface
    
    static let shared = MIDISequencer()
    
    /**
     Midi notes
     */
    var MIDIs: [MIDINote] {
        didSet {
            createTimer()
        }
    }
    
    var instrument: MIDIInstrument {
        didSet {
            synthesizer.changeInstrument(instrument: instrument)
        }
    }
    
    /**
     Trigger when Player finish
     */
    var didFinishPlay: (() -> Void)? = nil
    
    // MARK: - Values
    
    /**
     Timer to change oscillator on synthesizer
     */
    private var timers: [Timer] = []
    
    /**
     synthesizer to synthesize sound
     */
    let synthesizer = MIDISynthesizer()
    
    // MARK: - Life Cycle
    
    init(MIDIs: [MIDINote] = [], instrument: MIDIInstrument = .grandPiano) {
        self.MIDIs = MIDIs
        self.instrument = instrument
        
        createTimer()
    }
    
    // MARK: - Function
    
    private func createTimer() {
        // clear previous
        timers.removeAll()
        
        timers = MIDIs.enumerated()
            .map({ (index, note) -> Timer in
                let scheduleAt = acumulateTime(index: index)
                return .init(timeInterval: scheduleAt, repeats: false, block: { _ in
                    self.synthesizer.volume = note.volume
                    self.synthesizer.play(note: note.note + 12)
                })
            })
        
        timers.append(
            .init(timeInterval: totalTime(), repeats: false) { [weak self] _ in
                self?.didFinishPlay?()
                self?.synthesizer.volume = 0
            }
        )
    }

    
    func play() {
        timers.forEach { timer in
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    func stop() {
        timers.forEach{ $0.invalidate() }
        timers.removeAll()
    }
    
    private func acumulateTime(index: Int) -> TimeInterval {
        guard index >= 0, index < MIDIs.endIndex else {
            return .zero
        }
        
        return MIDIs[MIDIs.startIndex ..< index].reduce(into: TimeInterval.zero) { (previous, current) in
            previous += current.time
        }
    }
    
    private func totalTime() -> TimeInterval {
        MIDIs.reduce(into: TimeInterval.zero) { (previous, current) in
            previous += current.time
        }
    }
}
