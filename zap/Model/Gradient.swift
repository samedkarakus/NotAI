//
//  Gradient.swift
//  zap
//
//  Created by Samed Karakuş on 11.10.2024.
//

import Foundation
import UIKit

class GradientView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }

    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds

        // Define the bottom color (full opacity) and top color (zero opacity)
        let bottomColor = UIColor(red: 114/255.0, green: 53/255.0, blue: 240/255.0, alpha: 1.0).cgColor
        let topColor = UIColor(red: 114/255.0, green: 53/255.0, blue: 240/255.0, alpha: 0.0).cgColor
        
        gradientLayer.colors = [topColor, bottomColor] // Top color is transparent, bottom color is opaque
        
        // Set the gradient direction (from bottom to top)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1) // Start from the bottom
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)   // End at the top

        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // Update gradient frame on layout changes
        if let gradientLayer = self.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = self.bounds
        }
    }
}
