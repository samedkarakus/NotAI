//
//  HomeViewController.swift
//  NotAI
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
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var streakCircleView: UIImageView!
    @IBOutlet weak var streakLabelView: UIStackView!
    @IBOutlet weak var streakView: UIImageView!

    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var learningLabelView: UIStackView!
    @IBOutlet weak var learningNowView: UIImageView!

    var viewModel: HomeViewModel!

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        setupUIElements()
        
        if let timeLeftLabel = timeLeftLabel {
            viewModel?.startTimer(for: timeLeftLabel)
        } else {
            print("timeLeftLabel is nil")
        }

        if let bubbleView = bubbleView {
            viewModel?.animatePulsesIfNeeded(on: bubbleView)
        } else {
            print("bubbleView is nil")
        }
    }

    @objc func appDidBecomeActive() {
        if let bubbleView = bubbleView {
            viewModel?.animatePulsesIfNeeded(on: bubbleView)
        } else {
            print("bubbleView is nil in appDidBecomeActive")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    func setupUIElements() {
        let viewsToMakeCircular: [UIView] = [notificationView, inviteButton, learningNowView, streakView]
        let viewsToBlur: [UIView] = [notificationView, inviteButton, learningNowView, streakView]

        viewsToMakeCircular.forEach { makeCircular(view: $0) }
        viewsToBlur.forEach { addBlurredBackground($0) }

        if let streakCircleView = streakCircleView {
            addLabelsAroundCircle(view: streakCircleView, radius: (streakCircleView.bounds.size.width / 2) - 13, count: 10)
        }
    }
}
