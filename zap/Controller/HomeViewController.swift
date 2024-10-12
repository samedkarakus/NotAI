//
//  HomeViewController.swift
//  zap
//
//  Created by Samed Karakuş on 29.09.2024.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var titleLabelView: UIStackView!
    @IBOutlet weak var balloonView: UIImageView!
    
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var notificationView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var streakCircleView: UIImageView!
    @IBOutlet weak var streakLabelView: UIStackView!
    @IBOutlet weak var streakView: UIImageView!

    @IBOutlet weak var learningLabelView: UIStackView!
    @IBOutlet weak var learningNowView: UIImageView!

    var isAnimatingBalloon = false
    var pulseLayers: [CAShapeLayer] = []

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startBalloonAnimations()
        animatePulsesIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBalloonAnimations()
        removePulseLayers()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        setupUIElements()
        setupBalloonAnimations()
    }
    
    // MARK: - Pulse Animations

    func animatePulsesIfNeeded() {
        if pulseLayers.isEmpty {
            createPulse(view: bubbleView)
        } else {
            pulseLayers.enumerated().forEach { animatePulse(index: $0.offset) }
        }
    }

    @objc func appDidBecomeActive() {
        animatePulsesIfNeeded()
        startBalloonAnimations()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func createPulse(view: UIView) {
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
        pulseLayer.add(scaleAnimation, forKey: "scale")

        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = 2.0
        opacityAnimation.fromValue = 0.5
        opacityAnimation.toValue = 0.0
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        opacityAnimation.repeatCount = .greatestFiniteMagnitude
        pulseLayer.add(opacityAnimation, forKey: "opacity")
    }

    func removePulseLayers() {
        pulseLayers.forEach { $0.removeFromSuperlayer() }
        pulseLayers.removeAll()
    }
    
    // MARK: - UI Setup

    func setupUIElements() {
        makeCircular(view: profileImageView)
        addBlurredBackground(notificationView)
        makeCircular(view: notificationView)
        
        makeCircular(view: inviteButton)
        addBlurredBackground(inviteButton)
        
        makeCircular(view: learningNowView)
        addBlurredBackground(learningNowView)

        makeCircular(view: streakView)
        addBlurredBackground(streakView)

        addLabelsAroundCircle(view: streakCircleView, radius: (streakCircleView.bounds.size.width / 2) - 13, count: 10)
    }
    
    
    // MARK: - Balloon Animations

    func setupBalloonAnimations() {
        let smallRadiusViews = [learningNowView, learningLabelView]
        let largeRadiusViews = [streakLabelView, streakView, streakCircleView]
        
        for view in smallRadiusViews {
            setupBalloonAnimation(for: view!, radius: 4, duration: 10, clockwise: false)
        }
        
        for view in largeRadiusViews {
            setupBalloonAnimation(for: view!, radius: 6, duration: 12, clockwise: true)
        }
    }


    func setupBalloonAnimation(for view: UIView, radius: CGFloat, duration: TimeInterval, clockwise: Bool) {
        animateBalloon(view, radius: radius, duration: duration, clockwise: clockwise)
    }

    func startBalloonAnimations() {
        [self.learningNowView, self.learningLabelView, self.streakView, self.streakCircleView, self.streakLabelView].forEach {
            $0?.isHidden = false
        }
        setupBalloonAnimations()
    }

    func stopBalloonAnimations() {
        [learningNowView, learningLabelView, streakView, streakCircleView, streakLabelView].forEach {
            $0?.layer.removeAllAnimations()
            //resetBalloonPosition(view: $0)
        }
    }

    func animateBalloon(_ view: UIView, radius: CGFloat, duration: TimeInterval, clockwise: Bool) {
        let originalPosition = view.center
        let circularPath = UIBezierPath(arcCenter: originalPosition, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: clockwise)

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = circularPath.cgPath
        animation.duration = duration
        animation.repeatCount = .infinity
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        view.layer.add(animation, forKey: "circularMotion")
    }

}

//MARK: - Public Editing Functions

func makeCircular(view: UIView) {
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
