//
//  TimerManager.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation
import UIKit

class TimerManager {
    static let shared = TimerManager()
    
    private var timer: Timer?

    private init() {}
    
    // MARK: - Timer Functions
    func startTimer(for timeLabel: UILabel) {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateTimeLabel(for: timeLabel)
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func updateTimeLabel(for timeLabel: UILabel) {
        let date = Date()
        let calendar = Calendar.current
        let midnight = calendar.startOfDay(for: date).addingTimeInterval(24 * 60 * 60)
        
        let timeInterval = midnight.timeIntervalSince(date)
        let hoursLeft = Int(timeInterval) / 3600
        let minutesLeft = (Int(timeInterval) % 3600) / 60
        let secondsLeft = Int(timeInterval) % 60

        timeLabel.text = String(format: "%02d:%02d:%02d", hoursLeft, minutesLeft, secondsLeft)
    }
}
