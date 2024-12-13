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
        
        setupUI()
        setupViewModel()
    }
    
    private func setupUI() {
        let viewsToMakeCircular: [UIView] = [QrCodeView]
        viewsToMakeCircular.forEach { makeCircular(view: $0) }
        QrCodeView.layer.cornerRadius = 10
        
        let viewsToAddBlurredBackgroundToPressed: [UIView] = [QrCodeView]
        viewsToAddBlurredBackgroundToPressed.forEach { addBlurredBackgroundToPressedButton($0) }
    }
    
    private func setupViewModel() {
        viewModel = QRViewModel(qrData: "www.youtube.com")
        if let qrImage = viewModel.getQRCodeImage(for: createdQrCode.frame.size) {
            createdQrCode.image = qrImage
        }
    }
}
