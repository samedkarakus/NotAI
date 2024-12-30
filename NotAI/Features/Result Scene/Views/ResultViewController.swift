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
    @IBOutlet weak var errorTopicsTableView: UITableView!
    @IBOutlet weak var endQuizButtonView: UIButton!
    @IBOutlet weak var getMoreQuestionButtonView: UIButton!
    
    var viewModel = ErrorTopicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupView()
    }
    
    @IBAction func endQuizButtonPressed(_ sender: UIButton) {
        if let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as? HomeViewController {
            self.navigationController?.pushViewController(homeVC, animated: true)
        } else {
            print("MainViewController bulunamadı.")
        }
    }
    
    @IBAction func getMoreQuestionButtonPressed(_ sender: UIButton) {
        if let quizVC = self.storyboard?.instantiateViewController(withIdentifier: "QuizViewController") as? QuizViewController {
            self.navigationController?.pushViewController(quizVC, animated: true)
        } else {
            print("QuizViewController bulunamadı.")
        }
    }
    
    func setupView() {
        errorTopicsTableView.dataSource = self
        errorTopicsTableView.delegate = self
        errorTopicsTableView.register(UINib(nibName: Constants.ErrorTopicCellNibName, bundle: nil), forCellReuseIdentifier: Constants.ErrorTopicCellIdentifier)
        errorTopicsTableView.backgroundColor = .clear
        errorTopicsTableView.showsVerticalScrollIndicator = false
        
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
        viewModel.errors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = errorTopicsTableView.dequeueReusableCell(withIdentifier: Constants.ErrorTopicCellIdentifier, for: indexPath) as! ErrorTopicCell
        let error = viewModel.errors[indexPath.row]
        cell.errorTitle.text = error.topicTitle
        cell.errorDescription.text = error.topicDescription
        return cell
    }
}
