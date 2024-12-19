//
//  NoteCoordinator.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation
import UIKit

class NoteCoordinator {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(note: Note? = nil) {
        let noteViewController = NoteViewController()
        let noteViewModel = NoteViewModel(note: note)
        
        noteViewController.viewModel = noteViewModel
        navigationController.pushViewController(noteViewController, animated: true)
    }
}
