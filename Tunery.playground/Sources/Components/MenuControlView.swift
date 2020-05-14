//
//  MenuControlView.swift
//  Tunery
//
//  Created by Wendy Liga on 10/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

protocol MenuDelegate: AnyObject {
    /**
     When Play is triggered
     */
    func play(_ menu: MenuControlView)
    
    /**
     When Stop is triggered
     */
    func stop(_ menu: MenuControlView)
    
    /**
     When Save is Triggered
     */
    func save()
    
    /**
     When Load is Triggered
     */
    func load()
    
    /**
     When Adjust Triggered
     */
    func adjust()
    
    /**
     When Template triggered
     */
    func template()
    
    /**
     When Random triggered
     */
    func random()
}

final class MenuControlView: UIView {
    // MARK: - Interface
    
    weak var delegate: MenuDelegate?
    
    var isPlaying: Bool = false {
        didSet {
            playButton.setTitle(isPlaying ? "Stop" : "Play", for: .normal)
        }
    }
    
    // MARK: - Views
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tunery"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 32)
        
        return label
    }()
    
    private let playButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        button.addTarget(self, action: #selector(play), for: .touchUpInside)
        
        return button
    }()
    
    let saveButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Export", for: .normal)
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        return button
    }()
    
    let loadButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Import", for: .normal)
        button.addTarget(self, action: #selector(load), for: .touchUpInside)
        
        return button
    }()
    
    let adjustButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Adjust", for: .normal)
        button.addTarget(self, action: #selector(adjust), for: .touchUpInside)
        
        button.contentEdgeInsets = .init(top: 14, left: 20, bottom: 14, right: 20)
        
        return button
    }()
    
    let templateButton: Button = {
        let button = Button()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Template", for: .normal)
        button.addTarget(self, action: #selector(template), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life Cycle
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .darkBlueGray
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(playButton)
        addSubview(saveButton)
        addSubview(loadButton)
        addSubview(adjustButton)
        addSubview(templateButton)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            adjustButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            adjustButton.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: -14),
            saveButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            saveButton.trailingAnchor.constraint(equalTo: adjustButton.leadingAnchor, constant: -14),
            loadButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadButton.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -14),
            templateButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            templateButton.trailingAnchor.constraint(equalTo: loadButton.leadingAnchor, constant: -14),
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Function
    
    @objc
    private func play() {
        if isPlaying {
            delegate?.stop(self)
        } else {
            delegate?.play(self)
        }
    }
    
    @objc
    private func save() {
        delegate?.save()
    }
    
    @objc
    private func load() {
        delegate?.load()
    }
    
    @objc
    private func adjust() {
        delegate?.adjust()
    }
    
    @objc
    private func template() {
        delegate?.template()
    }
    
    @objc func random() {
        delegate?.random()
    }
}
