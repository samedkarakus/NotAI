//
//  ResultViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 25.11.2024.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var finalScoreView: UIView!
    @IBOutlet weak var errorTopicsTableView: UITableView!
    @IBOutlet weak var endQuizButtonView: UIButton!
    @IBOutlet weak var get10moreQuestionButtonView: UIButton!
    
    var viewModel = ErrorTopicViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupView()
    }
    
    func setupView() {
        errorTopicsTableView.dataSource = self
        errorTopicsTableView.delegate = self
        errorTopicsTableView.register(UINib(nibName: Constants.ErrorTopicCellNibName, bundle: nil), forCellReuseIdentifier: Constants.ErrorTopicCellIdentifier)
        makeButtonCircular(view: endQuizButtonView)
        makeButtonCircular(view: get10moreQuestionButtonView)
        addBlurredBackgroundToPressedButton(endQuizButtonView)
        addBlurredBackgroundToPressedButton(get10moreQuestionButtonView)
        errorTopicsTableView.backgroundColor = .clear
        errorTopicsTableView.showsVerticalScrollIndicator = false
        
        setCircularProgressView()
        makeCircular(view: finalScoreView)
        addBlurredBackground(finalScoreView)
    }
    
    func setCircularProgressView() {
        let progressView = CircularProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        finalScoreView.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.centerXAnchor.constraint(equalTo: finalScoreView.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: finalScoreView.centerYAnchor),
            progressView.widthAnchor.constraint(equalTo: finalScoreView.widthAnchor),
            progressView.heightAnchor.constraint(equalTo: finalScoreView.heightAnchor)
        ])
        progressView.score = 9
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
