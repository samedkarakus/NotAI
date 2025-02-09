//
//  NoteModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation

struct Note: Codable {
    var id: String
    var title: String
    var body: String
    var createdDate: Date
}
