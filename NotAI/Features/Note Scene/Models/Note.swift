//
//  NoteModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation

class Note {
    var title: String
    var body: String
    var createdDate: Date
    
    init(title: String, body: String, createdDate: Date) {
        self.title = title
        self.body = body
        self.createdDate = createdDate
    }
}
