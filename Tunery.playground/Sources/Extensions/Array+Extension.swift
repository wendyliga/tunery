//
//  Array+Extension.swift
//  Tunery
//
//  Created by Wendy Liga on 09/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return (startIndex <= index && index < endIndex) ? self[index] : nil
    }
    
    subscript(before index: Index) -> Element? {
        guard index - 1 >= startIndex else { return nil }
        
        return self[safe: index - 1]
    }
    
    subscript(next index: Index) -> Element? {
        guard index + 1 <= (endIndex - 1) else { return nil }
        
        return self[safe: index + 1]
    }
}
