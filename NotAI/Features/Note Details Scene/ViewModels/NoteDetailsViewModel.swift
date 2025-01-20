//
//  NoteDetailsViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 1.01.2025.
//

import Foundation

class NoteDetailsViewModel {
    var notes: [Note] = []

    func addNote(title: String, body: String) {
        let newNote = Note(title: title, body: body, createdDate: Date())
        notes.append(newNote)
    }
    
    var filteredNotes: [Note] = []

    func filteredNotes(by searchText: String) {
        if searchText.isEmpty {
            filteredNotes = notes
        } else {
            filteredNotes = notes.filter { note in
                note.title.lowercased().contains(searchText.lowercased()) ||
                note.body.lowercased().contains(searchText.lowercased())
            }
        }
    }
}
