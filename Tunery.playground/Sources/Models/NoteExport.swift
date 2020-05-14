//
//  NoteExport.swift
//  wwdc2020
//
//  Created by Wendy Liga on 15/05/20.
//  Copyright © 2020 Wendy Liga. All rights reserved.
//

import Foundation

/**
 Model to used as JSON export and import
 */
struct NoteExport: Codable {
    let bpm: Int
    let notes: [Note]
}
