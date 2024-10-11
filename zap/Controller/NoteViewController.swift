//
//  NoteViewController.swift
//  zap
//
//  Created by Samed Karakuş on 10.10.2024.
//

import UIKit

class NoteViewController: UIViewController  {
    
    @IBOutlet weak var cancelBtnView: UIButton!
    @IBOutlet weak var timeView: UIView!

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var noteTitleTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        textViewDidChange(noteTitleTextView)
        
        editShape(view: timeView)
        editShape(view: cancelBtnView)
        addGradientMask(to: gradientView)

        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.isScrollEnabled = false
        textView.frame.size.height = size.height
    }
    
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
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

func editShape(view: UIView) {
    view.layer.masksToBounds = true
    view.layer.cornerRadius = view.frame.height / 2
    let borderColor = UIColor.white.withAlphaComponent(0.25)
    view.layer.borderColor = borderColor.cgColor
    view.layer.borderWidth = 0.5
}

func addGradientMask(to view: UIView) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = view.bounds

    // Define the gradient colors
    gradientLayer.colors = [
        UIColor.clear.cgColor,    // Top - Fully visible
        UIColor.white.cgColor,    // Mid - Fully visible
        UIColor.white.cgColor     // Bottom - Transparent
    ]

    // Define where the color changes occur (0 means top, 1 means bottom)
    gradientLayer.locations = [0.0, 0.7, 1.0]

    // Apply the gradient mask to the UITextView's layer
    view.layer.mask = gradientLayer
}
