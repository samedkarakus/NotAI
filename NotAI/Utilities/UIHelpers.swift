//
//  UIHelpers.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import UIKit

var timerManager: TimerManager?
var pulseLayers: [CAShapeLayer] = []


func makeCircular(view: UIView) {
    view.layer.masksToBounds = true
    view.layer.cornerRadius = view.frame.height / 2
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.borderWidth = 0.5
}

func makeButtonCircular(view: UIView) {
    view.layer.masksToBounds = true
    view.layer.cornerRadius = view.frame.height / 3
    view.layer.borderColor = UIColor.white.cgColor
    view.layer.borderWidth = 0.5
}

func addBlurredBackground(_ view: UIView) {
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.insertSubview(blurEffectView, at: 0)
    blurEffectView.alpha = 0.9
}

func addBlurredBackgroundToPressedButton(_ view: UIView) {
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    blurEffectView.frame = view.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.insertSubview(blurEffectView, at: 0)
    blurEffectView.alpha = 0.99
}

func addLabelsAroundCircle(view: UIView, radius: CGFloat, count: Int) {
    let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    let offsetAngle = -(CGFloat.pi / 2)

    for i in 0..<count {
        let angle = (2 * CGFloat.pi / CGFloat(count)) * CGFloat(i) + offsetAngle
        let x = center.x + radius * cos(angle)
        let y = center.y + radius * sin(angle)

        let label = UILabel()
        label.text = "\(i + 2)"
        label.font = .systemFont(ofSize: 12)
        label.sizeToFit()
        label.center = CGPoint(x: x, y: y)
        label.textAlignment = .center
        label.textColor = i >= 4 ? .gray : .white

        view.addSubview(label)
    }
}

func editShape(view: UIView) {
    view.layer.masksToBounds = true
    view.layer.cornerRadius = view.frame.height / 2
    let borderColor = UIColor.white.withAlphaComponent(0.25)
    view.layer.borderColor = borderColor.cgColor
    view.layer.borderWidth = 0.5
}

func lineSpacing(_ space: CGFloat, for textView: UITextView) {
    if let text = textView.text, let currentFont = textView.font, let currentTextColor = textView.textColor {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: currentFont,
            .foregroundColor: currentTextColor
        ]

        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        textView.attributedText = attributedString
    }
}

func addPlaceholder(_ placeholder: String, for textView: UITextView) {
    textView.text = placeholder
    textView.textColor = UIColor.white.withAlphaComponent(0.25)
}

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
        animatePulse(index: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { animatePulse(index: 1) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { animatePulse(index: 2) }
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
