//
//  QuestionViewController.swift
//  zap
//
//  Created by Samed Karakuş on 18.10.2024.
//

import UIKit

class QuestionViewController: UIViewController {
    @IBOutlet weak var nextBtnView: UIButton!
    @IBOutlet weak var answersView: UIView!
    @IBOutlet weak var answer4BtnView: UIButton!
    @IBOutlet weak var answer3BtnView: UIButton!
    @IBOutlet weak var answer2BtnView: UIButton!
    @IBOutlet weak var answer1BtnView: UIButton!
    @IBOutlet weak var cancelBtnView: UIButton!
    @IBOutlet weak var questionNoView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        //editShape(view: cancelBtnView)
        //editShape(view: questionNoView)
        
        buttonViewEdition(view: cancelBtnView)
        buttonViewEdition(view: questionNoView)
        buttonViewEdition(view: nextBtnView)
        
        answerButtonViewEdition(view: answer1BtnView)
        answerButtonViewEdition(view: answer2BtnView)
        answerButtonViewEdition(view: answer3BtnView)
        answerButtonViewEdition(view: answer4BtnView)
        
        answerButtonsStackView(view: answersView)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func buttonViewEdition(view: UIView) {
        makeCircular(view: view)
        addBlurredBackground(view)
    }
    
    func answerButtonViewEdition(view: UIView) {
        answerButtonUI(view: view)
        addBlurredBackground(view)
    }
    
    func answerButtonUI(view: UIView) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height / 3
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.5
    }
    
    func answerButtonsStackView(view: UIView) {
        addBlurredBackground(view)
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = (view.frame.height + 15) / 12
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
