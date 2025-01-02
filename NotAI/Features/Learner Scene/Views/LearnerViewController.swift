//
//  LearnerViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 11.12.2024.
//

import UIKit

class LearnerViewController: UIViewController, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var learnerTableView: UITableView!
    
    var viewModel = LearnerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        viewModel.filteredLearners = viewModel.learners
        learnerTableView.dataSource = self
        learnerTableView.delegate = self
        learnerTableView.register(UINib(nibName: Constants.LearnerCellNibName, bundle: nil), forCellReuseIdentifier: Constants.LearnerCellIdentifier)
        learnerTableView.backgroundColor = .clear
        learnerTableView.showsVerticalScrollIndicator = false
        activateLightModeForSearchBar(to: searchBar)
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchBar.barStyle = .default
            searchTextField.font = UIFont.systemFont(ofSize: 14)
        }
        setupNavigationBar()
    }

    func setupNavigationBar() {
        navigationItem.title = "Konunu Öğrenenler"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterLearners(by: searchText)
        learnerTableView.reloadData()
    }
}

extension LearnerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredLearners.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = learnerTableView.dequeueReusableCell(withIdentifier: Constants.LearnerCellIdentifier, for: indexPath) as! LearnerCell
        let learner = viewModel.filteredLearners[indexPath.row]
        
        cell.learnerUserName.text = learner.username
        cell.learnerEmoji.image = learner.memoji
        cell.learnerTopic.text = learner.topic
        cell.similarityPercentage.text = String(learner.similarityPercentage)
        
        return cell
    }
}
