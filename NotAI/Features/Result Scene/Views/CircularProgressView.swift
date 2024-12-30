//
//  CircularProgressView.swift
//  NotAI
//
//  Created by Samed Karakuş on 26.12.2024.
//

import UIKit

class CircularProgressView: UIView {
    
    var Score: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius = min(rect.width, rect.height) / 2 - 10
        let lineWidth: CGFloat = 6
        

        
        context.setLineWidth(lineWidth)
        context.setStrokeColor(UIColor.white.cgColor)
        let endAngle = CGFloat(Score / 10) * 2 * CGFloat.pi
        context.addArc(center: center, radius: radius, startAngle: -CGFloat.pi / 2, endAngle: endAngle - CGFloat.pi / 2, clockwise: false)
        context.strokePath()
    }
}
