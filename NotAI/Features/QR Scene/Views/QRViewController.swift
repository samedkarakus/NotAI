//
//  QRViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 12.12.2024.
//

import UIKit

class QRViewController: UIViewController {
    
    @IBOutlet weak var createdQrCode: UIImageView!
    @IBOutlet weak var QrCodeView: UIView!
    
    private var viewModel: QRViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editModelBackground(for: QrCodeView)
        setupViewModel()
    }
    
    private func setupViewModel() {
        viewModel = QRViewModel(qrData: "https://www.instagram.com")
        updateQRCodeImage()
    }
    
    private func updateQRCodeImage() {
        if let qrImage = viewModel.getQRCodeImage(for: createdQrCode.frame.size) {
            createdQrCode.image = qrImage
        }
    }
}
