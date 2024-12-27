//
//  QRCodeGenerator.swift
//  NotAI
//
//  Created by Samed Karakuş on 13.12.2024.
//

import UIKit
import CoreImage

final class QRCodeGenerator {
    static let shared = QRCodeGenerator()
    
    public init() {}
    
    public func generateQRCode(from string: String, size: CGSize) -> UIImage? {
        guard let data = string.data(using: String.Encoding.ascii),
              let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        if let outputImage = filter.outputImage {
            let scaleX = size.width / outputImage.extent.size.width
            let scaleY = size.height / outputImage.extent.size.height
            let transformedImage = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
            
            return UIImage(ciImage: transformedImage)
        }
        return nil
    }
}

