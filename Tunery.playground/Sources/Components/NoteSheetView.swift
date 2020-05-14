//
//  NoteSheet.swift
//  Tunery
//
//  Created by Wendy Liga on 06/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

final class NoteSheetView: UIView {
    // MARK: - Interface

    /**
     Number of transpose, the possibility note to go down an up as much as this number
     */
    static let numberOfTranspose = 18
    
    /**
     Horizontal spacing each notes
     */
    static let spacing: CGFloat = 8
    
    /**
     All Note Views on `NoteSheetView`
     */
    var noteViews = [NoteView]()
    
    // MARK: - Values
    
    /**
     Determine how far note should move on Y-Axis to be clasified as transpose
     
     based on `NoteLiveView` height divided by number of transpose.
     */
    private var transposeSpacing: CGFloat {
        frame.height / (CGFloat(NoteSheetView.numberOfTranspose))
    }
    
    /**
     Default Note
     */
    private let defaultNote: Note = .A
    
    /**
     Helper variable to save previous notes center y constant when translation, to avoid overlapping added value on new constant for y center axis
     */
    private var notesCenterConstantBeforeTranslation: [Int: CGFloat] = [:]
    
    var player = MIDISequencer(MIDIs: [])
    
    // MARK: - Views
    
    private let noteLine = NoteLineView()
    private var notesYAnchor = [NSLayoutConstraint]()
    
    private let orderLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 32)
        label.textColor = .laurelGreen
        label.text = "#1"
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    init(index: Int, notes: [Note] = (0..<MainViewController.maxNoteOnSheet).map{ _ in return .none }) {
        super.init(frame: .zero)
        
        assert(notes.count <= MainViewController.maxNoteOnSheet, "Maximum Note on Sheet")
        
        noteViews = notes.map { [weak self] note -> NoteView in
            let view = NoteView(note: note)
            view.gestureRecognizer = self
            
            return view
        }
        
        setupView(index: index)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        zip(noteViews.indices, noteViews).forEach { (index, value) in
            // calculate number of transpose to get transpose spacing
            // inverse -1 because transpose down is positive
            let spacing = CGFloat(defaultNote.numberOftranspose(to: value.noteKey)) * transposeSpacing * -1
            updateNotesAnchorAt(index: index, newConstant: spacing, willPlaySound: false)
        }
    }
    
    // MARK: - Function
    
    private func setupView(index: Int) {
        backgroundColor = .paleSpringBud
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(noteLine)
        addSubview(orderLabel)
        
        var constrains: [NSLayoutConstraint] = [
            orderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            orderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            noteLine.leadingAnchor.constraint(equalTo: orderLabel.trailingAnchor, constant: 24),
            noteLine.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -48),
            noteLine.topAnchor.constraint(equalTo: topAnchor),
            bottomAnchor.constraint(equalTo: noteLine.bottomAnchor)
        ]
        
        /// dynamically set each notes constraint
        ///
        /// each note will constraint to each other on horizontal side
        constrains += noteViews.enumerated()
            .map ({ index, note -> [NSLayoutConstraint] in
                // add note to subview
                addSubview(note)
                
                // save current Y anchor constraint, for animation purpose
                let centerYConstraint = note.centerYAnchor.constraint(equalTo: centerYAnchor)
                centerYConstraint.identifier = "centerYConstraint"
                
                notesYAnchor.insert(centerYConstraint, at: index)
                
                var constraints = [
                    notesYAnchor[index]
                ]

                let respectiveSpacing = (CGFloat(index) * NoteSheetView.spacing)
                let calculatedLeading = respectiveSpacing + NoteSheetView.spacing + (CGFloat(index) * NoteView.size.width)

                constraints.append(
                    // add padding from title
                    note.leadingAnchor.constraint(equalTo: orderLabel.trailingAnchor, constant: 24 + calculatedLeading)
                )

                // last index
                if index == noteViews.endIndex - 1 {
                    constraints.append(
                        trailingAnchor.constraint(equalTo: note.trailingAnchor, constant: 48 + NoteSheetView.spacing)
                    )
                }

                return constraints
            })
            .flatMap { $0 }
        
        NSLayoutConstraint.activate(constrains)
        
        orderLabel.text = "#" + String(index + 1)
    }
    
    /// Transposing `NoteView` key based on centerYConstant
    private func transposeNoteView(
        at index: Int,
        centerYConstant: CGFloat,
        willPlay: Bool = true
    ) {
        guard let currentNote = self.noteViews[safe: index] else { return }
        
        // calculate how many transpose needed for current new constant
        let numberOfTransposeNeeded = Int(round(centerYConstant / transposeSpacing))
        
        // Determining transpose up or down based on numberOfTransposeNeeded positif or negatif value
        let direction: Transpose = numberOfTransposeNeeded > 0 ? .down : .up

        // get new note that being transpose
        var newNote = defaultNote
        newNote.transpose(direction, count: abs(numberOfTransposeNeeded))
        
        if currentNote.noteKey != newNote && willPlay{
            play(note: newNote)
        }
        
        // set new note
        self.noteViews[index].noteKey = newNote
    }
    
    /// update y anchor at spesific index and apply the effect by animating the changes
    private func updateNotesAnchorAt(
        index: Int,
        newConstant: CGFloat,
        willPlaySound: Bool = true,
        completion: (() -> Void)? = nil
    ) {
        
        // make sure anchor array and notes array contains this index
        guard notesYAnchor[safe: index] != nil && noteViews[safe: index] != nil else { return }
        
        // update anchor
        self.notesYAnchor[index].constant = newConstant
        
        // mark the view "dirty", to get recalculate by auto layout
        self.noteViews[index].layoutIfNeeded()
        
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            self?.layoutIfNeeded()
        }, completion: { [weak self] _ in
            // transpose note on NoteView
            self?.transposeNoteView(at: index, centerYConstant: newConstant, willPlay: willPlaySound)
            
            completion?()
        })
    }
    
    private func play(note: Note) {
        MIDISequencer.shared.MIDIs = [note].MIDIs(duration: 0.5)
        MIDISequencer.shared.play()
    }
}

extension NoteSheetView: NoteViewGestureRecognizer {
    func beginPan(_ view: NoteView) {
        guard
            let index = noteViews.firstIndex(of: view),
            let currentYAnchor = notesYAnchor[safe: index]
        else { return }
    
        // save previous center y constant before translation
        notesCenterConstantBeforeTranslation[index] = currentYAnchor.constant
    }
    
    func didPan(_ view: NoteView, at position: CGPoint) {
        // find index of panned view
        guard let index = noteViews.firstIndex(of: view) else { return }
        
        // disable pan if current height is smaller than note height
        guard frame.height >= view.frame.height else { return }
        
        // find last center constant before translation or default 0 (center y)
        let previousConstant = notesCenterConstantBeforeTranslation[index] ?? 0
        let maxYTranslation = (frame.height / 2) - (view.frame.height / 2)
        
        let newContant = (previousConstant + position.y).clamp(-maxYTranslation ... maxYTranslation)
        
        // animate note that being panned
        updateNotesAnchorAt(index: index, newConstant: newContant)
    }
    
    func stopPan(_ view: NoteView, at position: CGPoint) {
        // find index of panned view
        guard
            let index = noteViews.firstIndex(of: view),
            let currentCenterYAnchor = notesYAnchor[safe: index]
        else { return }
        
        // estimating snap position
        let estimatedTransposeCount = round(currentCenterYAnchor.constant / transposeSpacing)
        let snapToTransposeConstant = estimatedTransposeCount * transposeSpacing
        
        // animate it
        updateNotesAnchorAt(index: index, newConstant: snapToTransposeConstant)
    }
    
    func didTap(_ view: NoteView) {
        play(note: view.noteKey)
        
        // animate it
        view.animateBeingTapped()
    }
}
