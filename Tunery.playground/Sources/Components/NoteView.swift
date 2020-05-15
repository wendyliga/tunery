//
//  NoteView.swift
//  Tunery
//
//  Created by Wendy Liga on 06/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

protocol NoteViewGestureRecognizer: AnyObject {
    /**
     Will be trigger when pan gesture started
     */
    func beginPan(_ view: NoteView)
    
    /**
     Will be triggered when pan gesture is triggered
     
     - Parameters:
        - view: NoteView
        - changesAt: current translation
     */
    func didPan(_ view: NoteView, at position: CGPoint)
    
    /**
     Will be triggered when pan gesture is stopped
     */
    func stopPan(_ view: NoteView, at position: CGPoint)
    
    /**
     Will be triggered when tap recognizer is triggered
     */
    func didTap(_ view: NoteView)
}

final class NoteView: UIView {
    // MARK: - Interface
    
    /**
     Note Size
     */
    static let size = CGSize(width: 46, height: 46)
    
    /**
     Note Key
     */
    var noteKey: Note = .A {
        didSet {
            updateViewFromNote(noteKey)
        }
    }
    
    /**
     will deliver any gesture recognizer
     */
    weak var gestureRecognizer: NoteViewGestureRecognizer?
    
    // MARK: - Views
    
    private let label: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "E"
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
    
    // MARK: - Life Cycle
    
    init(note: Note = .G) {
        self.noteKey = note

        super.init(frame: .zero)
        
        backgroundColor = .systemPurple
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 32
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    private func setupView() {
        addSubview(label)
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: Self.size.width),
            heightAnchor.constraint(equalToConstant: Self.size.height),
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // update label and color based on note key
        updateViewFromNote(noteKey)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tap))
        label.addGestureRecognizer(panGesture)
        label.addGestureRecognizer(tapGesture)
    }
    
    private func updateViewFromNote(_ note: Note) {
        label.text = note.key.symbol
        backgroundColor = note.color
        label.backgroundColor = note.color
    }
    
    @objc
    private func pan(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            gestureRecognizer?.beginPan(self)
            
            // set focus
            alpha = 0.85
        }
        
        if sender.state == .changed {
            gestureRecognizer?.didPan(self, at: sender.translation(in: self))
        }
        
        if sender.state == .ended {
            gestureRecognizer?.stopPan(self, at: sender.translation(in: self))
            
            // set unfocus
            alpha = 1
        }
    }
    
    @objc
    private func tap() {
        gestureRecognizer?.didTap(self)
    }
}

extension NoteView {
    enum PanDirection {
        case up
        case down
    }
}

extension NoteView {
    func animateBeingTapped() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = .init(scaleX: 0.5, y: 0.5)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.transform = .init(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.transform = .init(scaleX: 0.9, y: 0.9)
                }) { _ in
                    UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                        self.transform = .identity
                    })
                }
            }
            
        }
    }
    
    func animateBeingPlayed() {
        UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = .init(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                self.transform = .init(scaleX: 0.8, y: 0.8)
            }) { _ in
                UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.transform = .init(scaleX: 1.1, y: 1.1)
                }) { _ in
                    UIView.animate(withDuration: 0.05, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                        self.transform = .identity
                    })
                }
            }
            
        }
    }
}
