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
        // UINavigationController oluşturuluyor
        navigationController = UINavigationController()
        
        // NoteCoordinator başlatılıyor ve UINavigationController'ı geçiriyoruz
        let noteCoordinator = NoteCoordinator(navigationController: navigationController!)
        
        // NoteCoordinator'ı başlatıyoruz
        noteCoordinator.start()
        
        // RootViewController olarak navigationController ayarlanıyor
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
