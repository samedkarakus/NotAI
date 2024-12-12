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
    
    var learnerCells: [LearnerModel] = [
        LearnerModel(username: "Merve Kaya", topic: "Dalga Fonksiyonları", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 92),
        LearnerModel(username: "Gizem Çalışkan", topic: "Hamilton Fonksiyonları", memoji: UIImage(named: "emoji_2")!, similarityPercentage: 91),
        LearnerModel(username: "Alp Altan", topic: "Yayılma Denklemleri", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 88),
        LearnerModel(username: "Furkan Yıldırım", topic: "Fourier Serileri", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 88),
        LearnerModel(username: "Elif Aksoy", topic: "Poisson Denklemleri", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 86),
        LearnerModel(username: "Eren Özdemir", topic: "Kısmi Diferansiyel Denklemler", memoji: UIImage(named: "emoji_2")!, similarityPercentage: 85),
        LearnerModel(username: "Emre Tunç", topic: "Kuadratik Denklemler", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 84),
        LearnerModel(username: "Derya Aydın", topic: "Harmonik Denklemler", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 83),
        LearnerModel(username: "Ahmet Çelik", topic: "Sınır Değer Problemleri", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 81),
        LearnerModel(username: "Samed Karakuş", topic: "Green Fonksiyonları ve Diferansiyel Denklemler", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 78),
        LearnerModel(username: "Betül Koç", topic: "Laplace Denklemleri", memoji: UIImage(named: "emoji_2")!, similarityPercentage: 77),
        LearnerModel(username: "Cem Kılıç", topic: "Bölgesel Değer Problemleri", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 74),
        LearnerModel(username: "Zeynep Demir", topic: "Doğrusal Denklem Sistemleri", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 72),
        LearnerModel(username: "Bora Şen", topic: "Karmaşık Analiz ve Denklemler", memoji: UIImage(named: "emoji_2")!, similarityPercentage: 79),
        LearnerModel(username: "Ayşe Yılmaz", topic: "Dikey Denklemleri", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 65)
    ]
    
    var filteredLearnerCells: [LearnerModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let searchTextField = searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.font = UIFont.systemFont(ofSize: 14)
        }
        
        filteredLearnerCells = learnerCells
        
        learnerTableView.dataSource = self
        learnerTableView.delegate = self
        learnerTableView.register(UINib(nibName: Constants.LearnerCellNibName, bundle: nil), forCellReuseIdentifier: Constants.LearnerCellIdentifier)
        learnerTableView.backgroundColor = .clear
        learnerTableView.showsVerticalScrollIndicator = false
        
        navigationItem.title = "Konunu Öğrenenler"
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black,
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        
        let backButtonImage = UIImage(systemName: "chevron.left")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: .default)
    }
    
    // Search Bar Metotları
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Arama kutusu boşsa tüm listeyi göster
            filteredLearnerCells = learnerCells
        } else {
            // Arama kutusu doluysa filtrele
            filteredLearnerCells = learnerCells.filter { learner in
                learner.username.lowercased().contains(searchText.lowercased()) ||
                learner.topic.lowercased().contains(searchText.lowercased())
            }
        }
        learnerTableView.reloadData()
    }

}

// MARK: - TableView DataSource & Delegate
extension LearnerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLearnerCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = learnerTableView.dequeueReusableCell(withIdentifier:  Constants.LearnerCellIdentifier , for: indexPath) as! LearnerCell
        let learner = filteredLearnerCells[indexPath.row]
        cell.learnerUserName.text = learner.username
        cell.learnerEmoji.image = learner.memoji
        cell.leernerTopic.text = learner.topic
        cell.similarityPercentage.text = String(learner.similarityPercentage)
        
        return cell
    }
}
