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
    
    // Coordinator, bir UINavigationController ile başlatılacak
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(note: Note? = nil) {
        let noteViewController = NoteViewController()
        
        // NoteViewModel'ı başlatırken, note parametresi geçirilir
        let noteViewModel = NoteViewModel(note: note)
        
        // ViewModel'i view controller'a bağla
        noteViewController.viewModel = noteViewModel
        
        // ViewController'ı navigasyon yığınına ekle
        navigationController.pushViewController(noteViewController, animated: true)
    }
}
