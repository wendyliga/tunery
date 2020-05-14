//
//  UIColor+Extension.swift
//  wwdc2020
//
//  Created by Wendy Liga on 06/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import UIKit

extension UIColor {
    static let paleSpringBud = UIColor(red: 229/255, green: 232/255, blue: 182/255, alpha: 1)
    static let laurelGreen = UIColor(red: 180/255, green: 196/255, blue: 174/255, alpha: 1)
    static let silverChalice = UIColor(red: 162/255, green: 171/255, blue: 171/255, alpha: 1)
    static let rowanSilver = UIColor(red: 125/255, green: 134/255, blue: 156/255, alpha: 1)
    static let darkBlueGray = UIColor(red: 88/255, green: 105/255, blue: 148/255, alpha: 1)
}

extension UIColor {
    static func from(key: Key, octave: Int) -> UIColor? {
        if key == .none {
            return .systemGray
        }
        
        if (key == .C || key == .D || key == .E) && octave == 4 {
            return UIColor(red: 180/255, green: 196/255, blue: 174/255, alpha: 1)
        }
        
        if (key == .F || key == .G || key == .A) && octave == 4 {
            return UIColor(red: 195/255, green: 208/255, blue: 190/255, alpha: 1)
        }
        
        if (key == .B && octave == 4) || ((key == .C || key == .D) && octave == 5) {
            return UIColor(red: 203/255, green: 214/255, blue: 198/255, alpha: 1)
        }
        
        if (key == .E || key == .F || key == .G || key == .A) && octave == 5 {
            return UIColor(red: 210/255, green: 220/255, blue: 206/255, alpha: 1)
        }
        
        return nil
    }
}

