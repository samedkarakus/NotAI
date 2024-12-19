//
//  AppCoordinator.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import UIKit

class AppCoordinator {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func start() {
        navigationController = UINavigationController()
    
        let noteCoordinator = NoteCoordinator(navigationController: navigationController!)
        noteCoordinator.start()
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
