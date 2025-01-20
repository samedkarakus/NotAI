//
//  ResultViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 25.11.2024.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var finalScoreView: UIView!
    @IBOutlet weak var incorrectQuestionsTableView: UITableView!
    @IBOutlet weak var endQuizButtonView: UIButton!
    @IBOutlet weak var getMoreQuestionButtonView: UIButton!
    
    private var viewModel = IncorrectQuestionsViewModel()
    private var incorrectAnswers: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupView()
    }
    
    @IBAction func endQuizButtonPressed(_ sender: UIButton) {
        if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? HomeViewController {
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true)
        } else {
            print("MainViewController bulunamadı.")
        }
    }
    
    @IBAction func getMoreQuestionButtonPressed(_ sender: UIButton) {
        // Yeni sorulara geçiş için yeni API çağrılacak
        if let quizVC = self.storyboard?.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController {
            quizVC.modalPresentationStyle = .fullScreen
            self.present(quizVC, animated: true)
        } else {
            print("QuizViewController bulunamadı.")
        }
    }
    
    func setupView() {
        viewModel.incorrectAnsweredQuestions = incorrectAnsweredQuestions
        incorrectQuestionsTableView.dataSource = self
        incorrectQuestionsTableView.delegate = self
        incorrectQuestionsTableView.register(UINib(nibName: Constants.IncorrectQuestionCellNibName, bundle: nil),
            forCellReuseIdentifier: Constants.IncorrectQuestionCellIdentifier
        )
        incorrectQuestionsTableView.backgroundColor = .clear
        incorrectQuestionsTableView.showsVerticalScrollIndicator = false
        incorrectQuestionsTableView.reloadData()
        
        [endQuizButtonView, getMoreQuestionButtonView].enumerated().forEach { index, button in
            button?.isUserInteractionEnabled = true
            makeCircular(view: button!)
        }
        
        setCircularProgressView()
        makeCircular(view: finalScoreView)
        addBlurredBackground(finalScoreView)
    }
    
    func setCircularProgressView() {
        let progressView = CircularProgressView()
        progressView.Score = CGFloat(score)
        scoreLabel.text = "\(score)"
        progressView.translatesAutoresizingMaskIntoConstraints = false
        finalScoreView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: finalScoreView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: finalScoreView.centerYAnchor),
            progressView.widthAnchor.constraint(equalTo: finalScoreView.widthAnchor),
            progressView.heightAnchor.constraint(equalTo: finalScoreView.heightAnchor)
        ])
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getAllIncorrectQuestions().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.IncorrectQuestionCellIdentifier,
            for: indexPath
        ) as? ErrorTopicCell else {
            return UITableViewCell()
        }
        
        let incorrect = viewModel.getAllIncorrectQuestions()[indexPath.row]
        cell.errorTitle.text = incorrect.question
        cell.errorUserAnswer.attributedText = formatText(fullText: "Cevabınız: \(incorrect.userAnswer)", highlightText: "\(incorrect.userAnswer)")
        cell.errorCorrectAnswer.attributedText = formatText(fullText: "Doğru Cevap: \(incorrect.correctAnswer)", highlightText: "\(incorrect.correctAnswer)")
        return cell
    }
}

private func formatText(fullText: String, highlightText: String) -> NSAttributedString {
    let attributedText = NSMutableAttributedString(string: fullText)
    if let range = fullText.range(of: highlightText) {
        let nsRange = NSRange(range, in: fullText)
        attributedText.addAttribute(.foregroundColor, value: UIColor.darkGray, range: nsRange)
    }
    return attributedText
}
