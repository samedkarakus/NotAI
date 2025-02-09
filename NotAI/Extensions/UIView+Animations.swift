//
//  UIView+Animations.swift
//  NotAI
//
//  Created by Samed Karakuş on 26.01.2025.
//

import UIKit

var pulseLayers: [CAShapeLayer] = []

extension UIView {
    
    func animateBalloon(_ view: UIView, radius: CGFloat, duration: TimeInterval, clockwise: Bool) {
         guard view.layer.animation(forKey: "balloonAnimation") == nil else { return }
         
         let originalPosition = view.center
         let circularPath = UIBezierPath(arcCenter: originalPosition, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: clockwise)
         
         let animation = CAKeyframeAnimation(keyPath: "position")
         animation.path = circularPath.cgPath
         animation.duration = duration
         animation.repeatCount = .infinity
         animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
         
         view.layer.position = originalPosition
         view.layer.add(animation, forKey: "balloonAnimation")
     }

     func animatePulsesIfNeeded(on view: UIView) {
         if pulseLayers.isEmpty {
             createPulse(view: view)
         } else {
             pulseLayers.enumerated().forEach { animatePulse(index: $0.offset) }
         }
     }
    
    func createPulse(view: UIView) {
        let screenWidth = UIScreen.main.bounds.size.width
        let radius = screenWidth / 2.0
        
        if pulseLayers.isEmpty {
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
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { self.animatePulse(index: 1) }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { self.animatePulse(index: 2) }
        }
    }
        
    func animatePulse(index: Int) {
        guard index < pulseLayers.count else { return }

        let pulseLayer = pulseLayers[index]
        pulseLayer.strokeColor = UIColor.purple.cgColor

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude

        pulseLayer.add(scaleAnimation, forKey: "scale")
        pulseLayer.add(opacityAnimation, forKey: "opacity")
    }
}
