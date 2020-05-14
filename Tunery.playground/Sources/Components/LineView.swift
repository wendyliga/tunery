//
//  LineView.swift
//  wwdc2020
//
//  Created by Wendy Liga on 06/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

final class LineView: UIView {
    // MARK: - Interface
    
    static let height: CGFloat = 6
    
    // MARK: - LifeCycle
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .laurelGreen
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: LineView.height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
