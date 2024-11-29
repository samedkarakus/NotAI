//
//  UITextView+Extensions.swift
//  zap
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation
import UIKit

extension UITextView {
    func setLineSpacing(_ spacing: CGFloat) {
        guard let text = self.text, let currentFont = self.font, let currentTextColor = self.textColor else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: currentFont,
            .foregroundColor: currentTextColor
        ]
        self.attributedText = NSMutableAttributedString(string: text, attributes: attributes)
    }

    func applyPlaceholder(_ placeholder: String, placeholderColor: UIColor = UIColor.white.withAlphaComponent(0.25)) {
        self.text = placeholder
        self.textColor = placeholderColor
    }
}

