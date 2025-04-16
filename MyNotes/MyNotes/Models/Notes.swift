//
//  Notes.swift
//  Ai Notes
//
//  Created by Zayn on 18/02/25.
//

import SwiftData
import Foundation

@Model
class Note {
    var id: UUID
    var title: String
    var content = ""
    var createdOn: Date
    var imageDataArray: [Data] = []
    
    init(id: UUID = UUID(), title: String, content: String, createdOn: Date, imageDataArray: [Data] = []) {
        self.id = id
        self.title = title
        self.content = content
        self.createdOn = createdOn
        self.imageDataArray = imageDataArray
    }
}

