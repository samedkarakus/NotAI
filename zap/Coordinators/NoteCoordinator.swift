//
//  NoteCoordinator.swift
//  zap
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation
import UIKit

class NoteCoordinator {
    func start() {
        let noteViewController = NoteViewController()
        let noteViewModel = NoteViewModel(noteTitle: "New Note", noteContent: "This is a new note.")
        noteViewController.viewModel = noteViewModel
        
        // Navigasyon işlemleri burada yapılabilir
    }
}


