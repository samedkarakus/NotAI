//
//  UIView+Extensions.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation
import UIKit

extension UIView {
    func applyRoundedStyle(borderColor: UIColor = UIColor.white.withAlphaComponent(0.25)) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = 0.5
    }
}
