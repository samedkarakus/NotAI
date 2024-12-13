//
//  QRViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 13.12.2024.
//

import UIKit

class QRViewModel {
    private let qrCodeGenerator = QRCodeGenerator()
    var qrData: String
    
    init(qrData: String) {
        self.qrData = qrData
    }
    
    func getQRCodeImage(for size: CGSize) -> UIImage? {
        return qrCodeGenerator.generateQRCode(from: qrData, size: size)
    }
}
