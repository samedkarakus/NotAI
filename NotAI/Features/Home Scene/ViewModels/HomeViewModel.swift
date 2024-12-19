//
//  HomeViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation
import UIKit

class HomeViewModel {
    
    var model: HomeModel

    init(model: HomeModel) {
        self.model = model
    }
    
    func updateTimeLeft() -> String {
        return model.timeLeft
    }
    
    func getStreakCount() -> Int {
        return model.streakCount
    }
    
    func isUserLearning() -> Bool {
        return model.isLearning
    }
}
