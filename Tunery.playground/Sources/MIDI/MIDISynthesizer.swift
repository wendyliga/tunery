//
//  MIDISynthesizer.swift
//  Tunery
//
//  Created by Wendy Liga on 13/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import AVFoundation
import Foundation

final class MIDISynthesizer {
    /**
     Change AVAudioEngine Volume
     */
    var volume: Float {
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            return audioEngine.mainMixerNode.outputVolume
        }
    }
 
    // MARK: - Values
    
    private var audioEngine = AVAudioEngine()
    
    private var engineInputFormat: AVAudioFormat? {
        AVAudioFormat(commonFormat: engineOutputFormat.commonFormat, sampleRate: sampleRate, channels: 1, interleaved: engineOutputFormat.isInterleaved)
    }
    
    private var engineOutputFormat: AVAudioFormat {
        audioEngine.outputNode.inputFormat(forBus: 0)
    }
    
    private var time: Float = 0
    
    private var sampleRate: Double {
        engineOutputFormat.sampleRate
    }
    
    private var deltaTime: Float {
        1 / Float(sampleRate)
    }
    
    /**
     Sampler to fill waveform on audio output
     */
    private var sampler = AVAudioUnitSampler()

    // MARK: - Life Cycle
 
    init() {
        loadSoundBank(sampler: &sampler, instrument: .grandPiano)
        
        audioEngine.attach(sampler)
        audioEngine.connect(sampler, to: audioEngine.mainMixerNode, format: engineInputFormat)
        audioEngine.connect(audioEngine.mainMixerNode, to: audioEngine.outputNode, format: nil)
        audioEngine.mainMixerNode.outputVolume = 0
        
        do {
           try audioEngine.start()
        } catch {
           fatalError("Could not start engine: \(error.localizedDescription)")
        }
    }
    
    func play(note: UInt8) {
        sampler.startNote(note, withVelocity: 120, onChannel: 0)
    }
    
    func changeInstrument(instrument: MIDIInstrument) {
        loadSoundBank(sampler: &sampler, instrument: instrument)
    }
}

func loadSoundBank(sampler: inout AVAudioUnitSampler, instrument: MIDIInstrument) {
    guard let soundFont = Bundle.main.url(forResource: "TimGM6mb", withExtension: "sf2") else {
        fatalError("Could not load Sound Bank Resource")
    }
    
    do {
        try sampler.loadSoundBankInstrument(at: soundFont, program: instrument.rawValue, bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB), bankLSB: 0)
    } catch {
        fatalError("Could not load sample: \(error.localizedDescription)")
    }
}
