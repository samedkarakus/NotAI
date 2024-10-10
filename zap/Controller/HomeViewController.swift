//
//  ViewController.swift
//  zap
//
//  Created by Samed Karakuş on 29.09.2024.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var titleLabelView: UIStackView!
    @IBOutlet weak var balloonView: UIImageView!
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var streakCircleView: UIImageView!
    @IBOutlet weak var streakLabelView: UIStackView!
    @IBOutlet weak var streakView: UIImageView!
    
    @IBOutlet weak var learningLabelView: UIStackView!
    @IBOutlet weak var learningNowView: UIImageView!
    
    var pulseLayers = [CAShapeLayer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        makeCircular(view: learningNowView, borderColor: UIColor.white, borderWidth: 0.5)
        addBlurredBackground(learningNowView)
        
        makeCircular(view: streakView, borderColor: UIColor.white, borderWidth: 0.5)
        addBlurredBackground(streakView)
        
        animateBalloon(learningNowView, radius: 3, duration: 12, clockwise: false)
        animateBalloon(learningLabelView, radius: 3, duration: 12, clockwise: false)
        
        addLabelsAroundCircle(view: streakCircleView, radius: (streakCircleView.bounds.size.width / 2) - 13, count: 10)
        animateBalloon(streakView, radius: 5, duration: 15, clockwise: true)
        animateBalloon(streakLabelView, radius: 5, duration: 15, clockwise: true)
        animateBalloon(streakCircleView, radius: 5, duration: 15, clockwise: true)
        
        createPulse(view: bubbleView)
    }
    
    
    //MARK: - UI Updates
    
    func addLabelsAroundCircle(view: UIView, radius: CGFloat, count: Int) {
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        let offSetAngle = -(CGFloat.pi / 2)

        for i in 0..<count {
            let angle = (2 * CGFloat.pi / CGFloat(count)) * CGFloat(i) + offSetAngle
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            let label = UILabel()
            label.textColor = .white
            label.font = .systemFont(ofSize: 12)
            label.text = "\(i + 2)"
            label.sizeToFit()
            label.center = CGPoint(x: x, y: y)
            label.textAlignment = .center
            
            if i >= 4 {
                label.textColor = .gray
            }
            
            view.addSubview(label)
        }
    }
    
    func makeCircular(view: UIView, borderColor: UIColor, borderWidth: CGFloat) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height / 2
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
    
    func animateBalloon(_ view: UIView, radius: CGFloat, duration: TimeInterval, clockwise: Bool) {
        let originalPosition = view.center
        
        let circularPath = UIBezierPath(arcCenter: originalPosition, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: clockwise)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = circularPath.cgPath
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        view.layer.position = originalPosition
        
        view.layer.add(animation, forKey: "circularMotion")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            view.layer.position = originalPosition
        }
    }
    
    func createPulse(view: UIView) {
        let screenWidth = UIScreen.main.bounds.size.width
        let radius = screenWidth / 2.0

        for _ in 0...2 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 3.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0)

            view.layer.insertSublayer(pulseLayer, at: 0)
            
            pulseLayers.append(pulseLayer)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.animatePulse(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.animatePulse(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.animatePulse(index: 2)
                }
            }
        }
    }

    func animatePulse(index: Int) {
        pulseLayers[index].strokeColor = UIColor.purple.cgColor

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2.0
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 0.9
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        scaleAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(scaleAnimation, forKey: "scale")
        
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayers[index].add(opacityAnimation, forKey: "opacity")
    }
}

