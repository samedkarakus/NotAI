//
//  QRViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 12.12.2024.
//

import UIKit

class QRViewController: UIViewController {
    
    @IBOutlet weak var QrCodeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewsToMakeCircular: [UIView] = [QrCodeView]
        viewsToMakeCircular.forEach { makeCircular(view: $0) }
        QrCodeView.layer.cornerRadius = 10
        
        let viewsToAddBlurredBackgroundToPressed: [UIView] = [QrCodeView]
        viewsToAddBlurredBackgroundToPressed.forEach { addBlurredBackgroundToPressedButton($0) }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
