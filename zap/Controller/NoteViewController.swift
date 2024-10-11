//
//  NoteViewController.swift
//  zap
//
//  Created by Samed Karakuş on 10.10.2024.
//
import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var cancelBtnView: UIButton!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var noteTitleTextView: UITextView!
    
    let titlePlaceholder = "Konu başlığı"
    let bodyPlaceholder = "Detaylar.."
    var timer: Timer?
    var isGradientAdded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer()
        
        noteTitleTextView.delegate = self
        noteBodyTextView.delegate = self
        addPlaceholder(titlePlaceholder, for: noteTitleTextView)
        addPlaceholder(bodyPlaceholder, for: noteBodyTextView)
        
        // Enable scrolling for noteBodyTextView
        noteBodyTextView.isScrollEnabled = true
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        textViewDidChange(noteTitleTextView)
        
        editShape(view: timeView)
        editShape(view: cancelBtnView)
        editShape(view: confirmBtn)
        lineSpacing(6, for: noteBodyTextView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isGradientAdded {
            let startColor = UIColor(red: 114/255, green: 53/255, blue: 240/255, alpha: 1.0).cgColor
            let endColor = UIColor(red: 114/255, green: 53/255, blue: 240/255, alpha: 0.0).cgColor

            let gradientLayer = CAGradientLayer()
            gradientLayer.colors = [endColor, startColor]
            gradientLayer.locations = [0.0, 0.7]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.frame = self.gradientView.bounds

            self.gradientView.layer.insertSublayer(gradientLayer, at: 0)

            isGradientAdded = true
        }
    }

    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.frame.size.height = size.height

        if textView == noteBodyTextView {
            noteBodyTextView.isScrollEnabled = true
            noteBodyTextView.scrollRangeToVisible(NSRange(location: textView.text.count - 1, length: 1))
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == titlePlaceholder || textView.text == bodyPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholders: [UITextView: (text: String, color: UIColor)] = [
            noteTitleTextView: (titlePlaceholder, UIColor.white.withAlphaComponent(0.25)),
            noteBodyTextView: (bodyPlaceholder, UIColor.white.withAlphaComponent(0.25))
        ]
        
        if textView.text.isEmpty, let placeholder = placeholders[textView] {
            textView.text = placeholder.text
            textView.textColor = placeholder.color
        }
    }
    
    // MARK: - Timer Settings
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }

    @objc func updateTimeLabel() {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)

        timeLabel.text = String(format: "%02d:%02d:%02d", hour, minute, second)
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

// Helper functions
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
