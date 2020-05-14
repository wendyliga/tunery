//
//  AdjustViewController.swift
//  Tunery
//
//  Created by Wendy Liga on 14/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

protocol AdjustDelegate: AnyObject {
    func didUpdate(bpm: Int)
    func didIncreaseSheetTo(_ sheet: Int)
    func didDecreaseSheetTo(_ sheet: Int)
    func didUpdate(instrument: MIDIInstrument)
}

final class AdjustViewController: UIViewController {
    // MARK: - Interface
    
    weak var delegate: AdjustDelegate?
    
    // MARK: - Values
    
    private var bpm = 125 {
        didSet {
            bpmValue.text = String(bpm)
            delegate?.didUpdate(bpm: bpm)
        }
    }
    
    private var sheet = 1 {
        didSet {
            sheetValue.text = String(sheet)
            
            if oldValue - sheet < 0 {
                delegate?.didIncreaseSheetTo(sheet)
            } else {
                delegate?.didDecreaseSheetTo(sheet)
            }
        }
    }
    
    private var instrument: MIDIInstrument = .grandPiano {
        didSet {
            instrumentValue.text = instrument.title
            delegate?.didUpdate(instrument: instrument)
        }
    }
    
    private var currentInstrumentIndex: Int? {
        MIDIInstrument.allCases.firstIndex(of: instrument)
    }
    
    // MARK: - Views
    
    private let bpmTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .paleSpringBud
        label.text = "BPM (Beat per Minute)"
        
        return label
    }()
    
    private lazy var bpmValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .darkBlueGray
        label.text = String(bpm)
        
        return label
    }()
    
    private let decreaseBPMButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.paleSpringBud, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(UIColor.gray, for: .disabled)
        
        button.setTitle("◄", for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 32)
        button.addTarget(self, action: #selector(decreaseBPM), for: .touchUpInside)
        
        return button
    }()
    
    private let increaseBPMButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.paleSpringBud, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(UIColor.gray, for: .disabled)
        
        button.setTitle("►", for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 32)
        button.addTarget(self, action: #selector(increaseBPM), for: .touchUpInside)
        
        return button
    }()
    
    private let sheetTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .paleSpringBud
        label.text = "Sheet"
        
        return label
    }()
    
    private lazy var sheetValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .darkBlueGray
        label.text = String(sheet)
        
        return label
    }()
    
    private let decreaseSheetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.paleSpringBud, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(UIColor.gray, for: .disabled)
        
        button.setTitle("◄", for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 32)
        button.addTarget(self, action: #selector(decreaseSheet), for: .touchUpInside)
        
        return button
    }()
    
    private let increaseSheetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.paleSpringBud, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(UIColor.gray, for: .disabled)
        
        button.setTitle("►", for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 32)
        button.addTarget(self, action: #selector(increaseSheet), for: .touchUpInside)
        
        return button
    }()
    
    private let instrumentTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .paleSpringBud
        label.text = "Instrument"
        
        return label
    }()
    
    private lazy var instrumentValue: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .darkBlueGray
        label.text = instrument.title
        
        return label
    }()
    
    private let backInstrumentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.paleSpringBud, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(UIColor.gray, for: .disabled)
        
        button.setTitle("◄", for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 32)
        button.addTarget(self, action: #selector(backInstrument), for: .touchUpInside)
        
        return button
    }()
    
    private let nextInstrumentButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.paleSpringBud, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        button.setTitleColor(UIColor.gray, for: .disabled)
        
        button.setTitle("►", for: .normal)
        
        button.titleLabel?.font = .boldSystemFont(ofSize: 32)
        button.addTarget(self, action: #selector(nextInstrument), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life Cycle
    
    init(sheet: Int, bpm: Int) {
        self.sheet = sheet
        self.bpm = bpm
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .silverChalice
        
        view.addSubview(bpmTitle)
        view.addSubview(bpmValue)
        view.addSubview(decreaseBPMButton)
        view.addSubview(increaseBPMButton)
        view.addSubview(sheetTitle)
        view.addSubview(sheetValue)
        view.addSubview(decreaseSheetButton)
        view.addSubview(increaseSheetButton)
        view.addSubview(instrumentTitle)
        view.addSubview(instrumentValue)
        view.addSubview(backInstrumentButton)
        view.addSubview(nextInstrumentButton)
        
        NSLayoutConstraint.activate([
            // BPM
            bpmTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 36),
            bpmTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bpmValue.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bpmValue.topAnchor.constraint(equalTo: bpmTitle.bottomAnchor, constant: 12),
            decreaseBPMButton.centerYAnchor.constraint(equalTo: bpmValue.centerYAnchor),
            decreaseBPMButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            decreaseBPMButton.trailingAnchor.constraint(equalTo: bpmValue.leadingAnchor, constant: -12),
            increaseBPMButton.centerYAnchor.constraint(equalTo: bpmValue.centerYAnchor),
            increaseBPMButton.leadingAnchor.constraint(equalTo: bpmValue.trailingAnchor, constant: 12),
            increaseBPMButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            // Sheet
            sheetTitle.topAnchor.constraint(equalTo: bpmValue.bottomAnchor, constant: 36),
            sheetTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sheetValue.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sheetValue.topAnchor.constraint(equalTo: sheetTitle.bottomAnchor, constant: 12),
            decreaseSheetButton.centerYAnchor.constraint(equalTo: sheetValue.centerYAnchor),
            decreaseSheetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            decreaseSheetButton.trailingAnchor.constraint(equalTo: sheetValue.leadingAnchor, constant: -12),
            increaseSheetButton.centerYAnchor.constraint(equalTo: sheetValue.centerYAnchor),
            increaseSheetButton.leadingAnchor.constraint(equalTo: sheetValue.trailingAnchor, constant: 12),
            increaseSheetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            
            // Instrument
            instrumentTitle.topAnchor.constraint(equalTo: sheetValue.bottomAnchor, constant: 36),
            instrumentTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instrumentValue.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            instrumentValue.topAnchor.constraint(equalTo: instrumentTitle.bottomAnchor, constant: 12),
            backInstrumentButton.centerYAnchor.constraint(equalTo: instrumentValue.centerYAnchor),
            backInstrumentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            backInstrumentButton.trailingAnchor.constraint(equalTo: instrumentValue.leadingAnchor, constant: -12),
            nextInstrumentButton.centerYAnchor.constraint(equalTo: instrumentValue.centerYAnchor),
            nextInstrumentButton.leadingAnchor.constraint(equalTo: instrumentValue.trailingAnchor, constant: 12),
            nextInstrumentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        ])
        
        validateBPMAction()
        validateSheetAction()
        validateInstrumentAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    @objc
    private func decreaseBPM() {
        bpm -= 5
        validateBPMAction()
    }
    
    @objc
    private func increaseBPM() {
        bpm += 5
        validateBPMAction()
    }
    
    private func validateBPMAction() {
        decreaseBPMButton.isEnabled = bpm <= 85 ? false : true
        increaseBPMButton.isEnabled = bpm >= 185 ? false : true
    }
    
    @objc
    private func decreaseSheet() {
        sheet -= 1
        validateSheetAction()
    }
    
    @objc
    private func increaseSheet() {
        sheet += 1
        validateSheetAction()
    }
    
    private func validateSheetAction() {
        decreaseSheetButton.isEnabled = sheet == 1 ? false : true
        increaseSheetButton.isEnabled = sheet > 50 ? false : true
    }
    
    @objc
    private func backInstrument() {
        guard
            let currentInstrumentIndex = currentInstrumentIndex,
            let newInstrument = MIDIInstrument.allCases[before: currentInstrumentIndex]
        else { return }
        
        instrument = newInstrument
        validateInstrumentAction()
    }
    
    @objc
    private func nextInstrument() {
        guard
            let currentInstrumentIndex = currentInstrumentIndex,
            let newInstrument = MIDIInstrument.allCases[next: currentInstrumentIndex]
        else { return }
    
        instrument = newInstrument
        validateInstrumentAction()
    }
    
    private func validateInstrumentAction() {
        backInstrumentButton.isEnabled = currentInstrumentIndex != 0
        nextInstrumentButton.isEnabled = currentInstrumentIndex != (MIDIInstrument.allCases.endIndex - 1)
    }
}
