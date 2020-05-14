//
//  CGFloat+Extension.swift
//  Tunery
//
//  Created by Wendy Liga on 09/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

extension CGFloat {
    /**
     Clamp value from range, with including range bounds as valid value
     */
    func clamp(_ interval: ClosedRange<Self>) -> Self {
        guard self >= interval.lowerBound else {
            return interval.lowerBound
        }
        
        guard self <= interval.upperBound else {
            return interval.upperBound
        }
        
        return self
    }
}
