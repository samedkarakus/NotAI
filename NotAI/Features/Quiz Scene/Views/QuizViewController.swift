//
//  QuestionViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 18.10.2024.
//

import UIKit

class QuizViewController: UIViewController {
    
    @IBOutlet weak var answersView: UIView!
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1Btn: UIButton!
    @IBOutlet weak var answer2Btn: UIButton!
    @IBOutlet weak var answer3Btn: UIButton!
    @IBOutlet weak var answer4Btn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var questionNoView: UIView!

    private var viewModel = QuizViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupUIElements()
    }

    func setupUIElements() {
        resetButtonStyles()

        questionLabel.text = viewModel.currentQuestion.question
        let answers = viewModel.currentQuestion.answer

        [answer1Btn, answer2Btn, answer3Btn, answer4Btn].enumerated().forEach { index, button in
            button?.setTitle(answers[index], for: .normal)
            button?.isUserInteractionEnabled = true
            makeCircular(view: button!)
            button?.layer.cornerRadius = 20
            button?.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        }

        questionNoLabel.text = "Soru \(viewModel.questionNumber)"
        makeCircular(view: questionNoView)
        makeCircular(view: cancelBtn)
        
        answersView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        answersView.layer.cornerRadius = 35
    }

    func resetButtonStyles() {
        [answer1Btn, answer2Btn, answer3Btn, answer4Btn].forEach { button in
            button?.backgroundColor = .clear
            button?.layer.borderWidth = 0
        }
    }

    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        viewModel.resetQuiz()
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        guard let answer = sender.title(for: .normal) else { return }
        viewModel.checkAnswer(answer)
        
        sender.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        
      
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if self.viewModel.nextQuestion() {
                self.setupUIElements()
            } else {
                if let resultViewController = self.storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController {
                    resultViewController.modalPresentationStyle = .fullScreen

                    self.present(resultViewController, animated: true, completion: nil)
                } else {
                    print("ResultViewController bulunamadı.")
                }
            }
        }
    }
}
