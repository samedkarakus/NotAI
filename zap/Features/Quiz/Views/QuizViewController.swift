//
//  QuestionViewController.swift
//  zap
//
//  Created by Samed Karakuş on 18.10.2024.
//

import UIKit

class QuizViewController: UIViewController {
    @IBOutlet weak var answersView: UIView!
    @IBOutlet weak var questionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1BtnView: UIButton!
    @IBOutlet weak var answer2BtnView: UIButton!
    @IBOutlet weak var answer3BtnView: UIButton!
    @IBOutlet weak var answer4BtnView: UIButton!
    @IBOutlet weak var cancelBtnView: UIButton!
    @IBOutlet weak var questionNoView: UIView!
    
    private var viewModel: QuizViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        let generator = QuizGenerator()
        let questions = generator.fetchQuestions()
        
        viewModel = QuizViewModel(questions: questions)
        setupUIElements()
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func setupUIElements() {
        resetButtonStyles()

        questionLabel.text = viewModel.currentQuestion.question
        let answerChoices = viewModel.currentQuestion.answer

        let buttons = [answer1BtnView, answer2BtnView, answer3BtnView, answer4BtnView]
        for (index, button) in buttons.enumerated() {
            button?.setTitle(answerChoices[index], for: .normal)
            button?.backgroundColor = .clear
            button?.isUserInteractionEnabled = true
        }

        questionNoLabel.text = "Soru \(viewModel.questionNumber)"
        questionNoView.backgroundColor = .clear

        let viewsToMakeCircular: [UIView] = [questionNoView, cancelBtnView]
        let viewsToBlur: [UIView] = [questionNoView, cancelBtnView]

        viewsToMakeCircular.forEach { makeCircular(view: $0) }
        viewsToBlur.forEach { addBlurredBackground($0) }
    }

    func resetButtonStyles() {
        let buttons = [answer1BtnView, answer2BtnView, answer3BtnView, answer4BtnView, questionNoView, cancelBtnView]
        for button in buttons {
            button?.backgroundColor = .clear
            button?.layer.borderWidth = 0
        }
    }

    @IBAction func answerButtonPressed(_ sender: UIButton) {
        addBlurredBackground(sender)
        makeButtonCircular(view: sender)
        addBlurredBackgroundToPressedButton(sender)
        sender.layer.borderWidth = 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let hasNext = self.viewModel.nextQuestion()
            if hasNext {
                self.setupUIElements()
            } else {
                self.showScore()
            }
        }
    }

    func showScore() {
        let alert = UIAlertController(
            title: "Quiz Tamamlandı",
            message: "Skorunuz: \(viewModel.score)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Yeniden Başla", style: .default) { _ in
            self.setupUIElements()
        })
        present(alert, animated: true, completion: nil)
    }
}
