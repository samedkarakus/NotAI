//
//  LearnerViewController.swift
//  NotAI
//
//  Created by Samed Karakuş on 11.12.2024.
//

import UIKit

class LearnerViewController: UIViewController {
    
    @IBOutlet weak var learnerTableView: UITableView!
    
    var learnerCells: [LearnerModel] = [
        LearnerModel(username: "Alp Altan", topic: "Yayılma Denklemleri", memoji: UIImage(named: "emoji1")!, similarityPercentage: 88),
        LearnerModel(username: "Samed Karakuş", topic: "Green Fonksiyonları ve Diferansiyel Denklemler", memoji: UIImage(named: "emoji2")!, similarityPercentage: 78),
        LearnerModel(username: "Ayşe Yılmaz", topic: "Dikey Denklemleri", memoji: UIImage(named: "emoji")!, similarityPercentage: 65)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        learnerTableView.dataSource = self
        learnerTableView.register(UINib(nibName: Constants.LearnerCellNibName, bundle: nil), forCellReuseIdentifier: Constants.LearnerCellIdentifier)
        learnerTableView.backgroundColor = .clear
        
        navigationItem.title = "Konunu Öğrenenler"
        
        // Navigation bar ayarları
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        // Back button text'ini gizle
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    }
}

extension LearnerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return learnerCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = learnerTableView.dequeueReusableCell(withIdentifier:  Constants.LearnerCellIdentifier , for: indexPath) as! LearnerCell
        cell.learnerUserName.text = learnerCells[indexPath.row].username
        cell.learnerEmoji.image = learnerCells[indexPath.row].memoji
        cell.leernerTopic.text = learnerCells[indexPath.row].topic
        cell.similarityPercentage.text = String(learnerCells[indexPath.row].similarityPercentage)
        
        return cell
    }
    
    
}
