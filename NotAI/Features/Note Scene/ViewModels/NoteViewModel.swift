//
//  NoteViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation

class NoteViewModel {
    
    var noteTitle: String
    var noteContent: String

    init(noteTitle: String, noteContent: String) {
        self.noteTitle = noteTitle
        self.noteContent = noteContent
    }

    func loadData() {
        // Verilerin yüklenmesi gibi işlemleri burada yapabilirsiniz
    }
}


