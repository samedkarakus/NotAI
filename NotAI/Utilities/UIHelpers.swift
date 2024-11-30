//
//  UIHelpers.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import UIKit


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
