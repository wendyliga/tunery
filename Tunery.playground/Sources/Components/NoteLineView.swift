//
//  NoteLineView.swift
//  wwdc2020
//
//  Created by Wendy Liga on 06/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

final class NoteLineView: UIView {
    // MARK: - Interface
    
    /**
     Spacing between line
     */
    static let itemSpacing: CGFloat = 32
    
    // MARK: - Views
    
    private var lines: [LineView] = []
    
    // MARK: - Life Cycle
    
    init(numberOfLines: Int = 5) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        lines = (0 ..< numberOfLines).map({ _ -> LineView in
            let view = LineView()
            addSubview(view)
            
            return view
        })
        
        // calculate additional height need to added on current view, so each note will note cut out the parent view bounds
        let maximumHeight = CGFloat(numberOfLines) * LineView.height + CGFloat(numberOfLines + 1) * NoteLineView.itemSpacing
        let additionalHeight = NoteView.size.height - (maximumHeight.truncatingRemainder(dividingBy: NoteView.size.height))
        
        let constraints = lines.enumerated()
            .map ({ (index, view) -> [NSLayoutConstraint] in
                var constraints = [
                    view.leadingAnchor.constraint(equalTo: leadingAnchor),
                    view.trailingAnchor.constraint(equalTo: trailingAnchor),
                    view.topAnchor.constraint(equalTo: topAnchor, constant: NoteLineView.itemSpacing + (CGFloat(index) * NoteLineView.itemSpacing) + (CGFloat(index) * LineView.height) + (additionalHeight / 2))
                ]
                
                if index == (lines.endIndex - 1) {
                    constraints.append(
                        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: NoteLineView.itemSpacing + additionalHeight / 2)
                    )
                }
                
                return constraints
            })
            .flatMap { $0 }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
