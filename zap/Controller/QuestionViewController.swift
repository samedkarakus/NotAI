//
//  QuestionViewController.swift
//  zap
//
//  Created by Samed Karakuş on 18.10.2024.
//

import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var answersView: UIView!
    @IBOutlet weak var questionNoView: UIView!
    
    @IBOutlet weak var answer4BtnView: UIButton!
    @IBOutlet weak var answer3BtnView: UIButton!
    @IBOutlet weak var answer2BtnView: UIButton!
    @IBOutlet weak var answer1BtnView: UIButton!
    @IBOutlet weak var cancelBtnView: UIButton!
    
    @IBOutlet weak var QuestionNoLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    // MARK: - Properties
    var quizBrain = QuizBrain()
    let quizGenerator = QuizGenerator()
    var correctAnswer: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        //fetchQuizQuestion()
        updateUI()
    }
    
    // MARK: - UI Update Methods
    @objc func updateUI() {
        questionLabel.text = quizBrain.getQuestion()
        let answerChoices = quizBrain.getAnswer()
        
        let buttons = [answer1BtnView, answer2BtnView, answer3BtnView, answer4BtnView]
        for (index, button) in buttons.enumerated() {
            button?.setTitle(answerChoices[index], for: .normal)
            button?.backgroundColor = UIColor.clear
        }
        
        // UI Özelleştirmelerini uygulayın
        customizeButton(cancelBtnView)
        customizeView(questionNoView)
        customizeAnswerButtons([answer1BtnView, answer2BtnView, answer3BtnView, answer4BtnView])
        configureAnswersView(answersView)
    }
    
    // MARK: - Actions
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        print("Button pressed.")
        let userAnswer = sender.currentTitle!
        let userGotItRight = quizBrain.checkAnswer(userAnswer)
        
        if userGotItRight {
            applyFeedbackBackground(view: sender, color: .green)
        } else {
            applyFeedbackBackground(view: sender, color: .red)
        }
        
        quizBrain.nextQuestion()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.updateUI()
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - API Call
    /*func fetchQuizQuestion() {
        let notes = "Photosynthesis is the process by which green plants and some other organisms use sunlight to synthesize foods with the help of chlorophyll."
        
        // Burada API çağrısını yapıyoruz
        quizGenerator.createQuizQuestion(from: notes) { [weak self] question, answers, correctAnswer in
            DispatchQueue.main.async {
                // API'den gelen verilerin geçerliliğini kontrol ediyoruz
                if let question = question, let answers = answers, answers.count == 4 {
                    self?.questionLabel.text = question
                    let answerButtons = [self?.answer1BtnView, self?.answer2BtnView, self?.answer3BtnView, self?.answer4BtnView]
                    for (index, answer) in answers.enumerated() {
                        answerButtons[index]?.setTitle(answer, for: .normal)
                    }
                    
                    self?.correctAnswer = correctAnswer
                } else {
                    // Eğer veri düzgün değilse, hata gösterme
                    self?.showError(message: "Received invalid question data.")
                }
            }
        }
        
        quizGenerator.createQuizQuestion(from: notes) { [weak self] question, answers, correctAnswer in
            print("Received Question: \(String(describing: question))")
            print("Received Answers: \(String(describing: answers))")
            DispatchQueue.main.async {
                if let question = question, let answers = answers, answers.count == 4 {
                    // Normal işlem...
                } else {
                    self?.showError(message: "Invalid data received from API.")
                }
            }
        }

    }*/

    
    // MARK: - Error Handling
    func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UI Customization Methods
    func customizeButton(_ view: UIView) {
        makeCircular(view: view)
        addBlurredBackground(view)
    }
    
    func customizeView(_ view: UIView) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = view.frame.height / 3
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.5
    }
    
    func customizeAnswerButtons(_ buttons: [UIView?]) {
        for view in buttons {
            if let buttonView = view {
                buttonView.layer.masksToBounds = true
                buttonView.layer.cornerRadius = buttonView.frame.height / 3
                buttonView.layer.borderColor = UIColor.white.cgColor
                buttonView.layer.borderWidth = 0.5
                addBlurredBackground(buttonView)
            }
        }
    }
    
    func configureAnswersView(_ view: UIView) {
        addBlurredBackground(view)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = (view.frame.height + 15) / 12
    }
    
    func applyFeedbackBackground(view: UIView, color: UIColor) {
        addBlurredBackground(view)
        view.backgroundColor = color
        view.layer.masksToBounds = true
        view.layer.cornerRadius = (view.frame.height + 15) / 12
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 0.5
    }
}
