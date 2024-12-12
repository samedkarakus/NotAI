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
    var timerManager: TimerManager
    var pulseLayers: [CAShapeLayer]

    init(model: HomeModel, timerManager: TimerManager) {
        self.model = model
        self.timerManager = timerManager
        self.pulseLayers = []
    }
    
    func startTimer(for label: UILabel) {
        timerManager.startTimer(for: label)
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
    
    // Pulse animation setup and handling
    func animatePulsesIfNeeded(on view: UIView) {
        if pulseLayers.isEmpty {
            createPulse(view: view)
        } else {
            pulseLayers.enumerated().forEach { animatePulse(index: $0.offset) }
        }
    }
    
    private func createPulse(view: UIView) {
        let screenWidth = UIScreen.main.bounds.size.width
        let radius = screenWidth / 2.0

        (0...2).forEach { _ in
            let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 3.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = .round
            pulseLayer.position = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)
            view.layer.insertSublayer(pulseLayer, at: 0)
            pulseLayers.append(pulseLayer)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.animatePulse(index: 1) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { self.animatePulse(index: 2) }
        }
    }

    private func animatePulse(index: Int) {
        guard index < pulseLayers.count else { return }

        let pulseLayer = pulseLayers[index]
        pulseLayer.strokeColor = UIColor.purple.cgColor

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayer.add(scaleAnimation, forKey: "scale")

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayer.add(opacityAnimation, forKey: "opacity")
    }
}
