//
//  HomeViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 29.09.2024.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: HomeViewModel!
    var timer: Timer?
    private var note: Note?
    let firebaseService: FirebaseService = .init()
    
    
    @IBOutlet weak var noteTitle: UILabel!
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
    @IBOutlet weak var learningNowImageView: UIImageView!
    @IBOutlet weak var learningNowView: UIImageView!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)

        setupNotifications()
        setupUIElements()
        startTimerIfNeeded()
        startBubbleAnimationsIfNeeded()
        startChangingTopics()
        loadCachedImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startBubbleAnimationsIfNeeded()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopBubbleAnimations()
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        timer?.invalidate()
    }
    
    // MARK: - Görselleri Yükleme
    private func loadCachedImages() {
        let imageMapping: [(imageName: String, imageView: UIImageView)] = [
            ("back1", backgroundView),
            ("ball", balloonView),
            ("learningNow", learningNowImageView),
            ("StreakCircle", streakCircleView)
        ]

        for mapping in imageMapping {
            if let cachedImage = ImageCacheManager.shared.getCachedImage(named: mapping.imageName) {
                mapping.imageView.image = cachedImage
            } else {
                print("Image not found: \(mapping.imageName)")
            }
        }
    }
    
    // MARK: - Setup Methods
    private func startChangingTopics() {
        //self.updateLabelWithRandomTopic()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            //self.updateLabelWithRandomTopic()
        }
    }
    
    /*func updateLabelWithRandomTopic() {
        firebaseService.fetchNotes { notes, error in
            if let error = error {
                print("Error fetching notes: \(error.localizedDescription)")
                self.noteTitle.text = "Notlar Yüklenemedi"
            } else if let notes = notes, !notes.isEmpty {
                let randomNote = notes.randomElement()
                DispatchQueue.main.async {
                    self.noteTitle.text = randomNote?.title ?? "Bilinmeyen Not"
                }
            } else {
                DispatchQueue.main.async {
                    self.noteTitle.text = "Kaydedilen Not Yok"
                }
            }
        }
    }*/
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }

    private func setupUIElements() {
        let circularViews: [UIView] = [notificationView, inviteButton, learningNowView, streakView]
        let blurredViews: [UIView] = [notificationView, learningNowView, streakView]

        circularViews.forEach { makeCircular(view: $0) }
        blurredViews.forEach { addBlurredBackground($0) }

        if let streakCircleView = streakCircleView {
            addLabelsAroundCircle(view: streakCircleView, radius: (streakCircleView.bounds.size.width / 2) - 13, count: 10)
        }

        startAnimations()
    }

    private func startTimerIfNeeded() {
        guard let timeLeftLabel = timeLeftLabel else {
            print("timeLeftLabel is nil")
            return
        }
        TimerManager.shared.startTimer(for: timeLeftLabel, foreword: "Kalan Süre: ")
    }

    private func startBubbleAnimationsIfNeeded() {
        guard let bubbleView = bubbleView else {
            print("bubbleView is nil")
            return
        }
        bubbleView.animatePulsesIfNeeded(on: bubbleView)
    }

    private func stopBubbleAnimations() {
        bubbleView?.layer.removeAllAnimations()
    }

    private func startAnimations() {
        learningNowView.animateBalloon(learningNowView, radius: 3, duration: 12, clockwise: false)
        learningLabelView.animateBalloon(learningLabelView, radius: 3, duration: 12, clockwise: false)
        streakView.animateBalloon(streakView, radius: 5, duration: 15, clockwise: true)
        streakLabelView.animateBalloon(streakLabelView, radius: 5, duration: 15, clockwise: true)
        streakCircleView.animateBalloon(streakCircleView, radius: 5, duration: 15, clockwise: true)
    }

    // MARK: - Notification Handlers
    @objc private func appDidBecomeActive() {
        startBubbleAnimationsIfNeeded()
    }
}
