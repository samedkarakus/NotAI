//
//  NoteViewController.swift
//  zap
//
//  Created by Samed Karakuş on 10.10.2024.
//

import UIKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var cancelBtnView: UIButton!
    @IBOutlet weak var timeView: UIView!

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var noteBodyTextView: UITextView!
    @IBOutlet weak var noteTitleTextView: UITextView!
    
    let titlePlaceholder = "Konu başlığı"
    let bodyPlaceholder = "Detaylar.."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noteTitleTextView.delegate = self
        noteBodyTextView.delegate = self
        addPlaceholder(titlePlaceholder, for: noteTitleTextView)
        addPlaceholder(bodyPlaceholder, for: noteBodyTextView)
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        textViewDidChange(noteTitleTextView)
        
        editShape(view: timeView)
        editShape(view: cancelBtnView)
        lineSpacing(6, for: noteBodyTextView)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
        textView.isScrollEnabled = false
        textView.frame.size.height = size.height
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == titlePlaceholder || textView.text == bodyPlaceholder{
            textView.text = ""
            textView.textColor = UIColor.white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = titlePlaceholder
            textView.textColor = UIColor.white.withAlphaComponent(0.25)
        }
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

func lineSpacing(_ space: CGFloat, for textView: UITextView) {
    if let text = textView.text, let currentFont = textView.font, let currentTextColor = textView.textColor {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = space

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: currentFont,
            .foregroundColor: currentTextColor
        ]

        let attributedString = NSMutableAttributedString(string: text, attributes: attributes)
        textView.attributedText = attributedString
    }
}

func addPlaceholder(_ placeholder: String, for textView: UITextView) {
    textView.text = placeholder
    textView.textColor = UIColor.white.withAlphaComponent(0.25)
}
