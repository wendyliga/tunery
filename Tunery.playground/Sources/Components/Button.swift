//
//  Button.swift
//  wwdc2020
//
//  Created by Wendy Liga on 13/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

class Button: UIButton {
    init() {
        super.init(frame: .zero)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        
        setTitleColor(.white, for: .normal)
        setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        setTitleColor(UIColor.gray, for: .disabled)
        
        layer.cornerRadius = 16
        layer.borderWidth = 4
        layer.borderColor = UIColor.laurelGreen.cgColor
        
        contentEdgeInsets = .init(top: 14, left: 12, bottom: 14, right: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
