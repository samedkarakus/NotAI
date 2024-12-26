//
//  LearnerViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 11.12.2024.
//

import Foundation
import UIKit

class LearnerViewModel {
    var learners: [Learner] = [
        Learner(username: "Merve Kaya", topic: "Dalga Fonksiyonları", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 92),
        Learner(username: "Gizem Çalışkan", topic: "Hamilton Fonksiyonları", memoji: UIImage(named: "emoji_2")!, similarityPercentage: 91),
        Learner(username: "Alp Altan", topic: "Yayılma Denklemleri", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 88),
        Learner(username: "Furkan Yıldırım", topic: "Fourier Serileri", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 88),
        Learner(username: "Elif Aksoy", topic: "Poisson Denklemleri", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 86),
        Learner(username: "Eren Özdemir", topic: "Kısmi Diferansiyel Denklemler", memoji: UIImage(named: "emoji_2")!, similarityPercentage: 85),
        Learner(username: "Emre Tunç", topic: "Kuadratik Denklemler", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 84),
        Learner(username: "Derya Aydın", topic: "Harmonik Denklemler", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 83),
        Learner(username: "Ahmet Çelik", topic: "Sınır Değer Problemleri", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 81),
        Learner(username: "Samed Karakuş", topic: "Green Fonksiyonları ve Diferansiyel Denklemler", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 78),
        Learner(username: "Betül Koç", topic: "Laplace Denklemleri", memoji: UIImage(named: "emoji_2")!, similarityPercentage: 77),
        Learner(username: "Cem Kılıç", topic: "Bölgesel Değer Problemleri", memoji: UIImage(named: "emoji_1")!, similarityPercentage: 74),
        Learner(username: "Zeynep Demir", topic: "Doğrusal Denklem Sistemleri", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 72),
        Learner(username: "Bora Şen", topic: "Karmaşık Analiz ve Denklemler", memoji: UIImage(named: "emoji_2")!, similarityPercentage: 79),
        Learner(username: "Ayşe Yılmaz", topic: "Dikey Denklemleri", memoji: UIImage(named: "emoji_3")!, similarityPercentage: 65)
    ]
    
    var filteredLearners: [Learner] = []

    func filterLearners(by searchText: String) {
        if searchText.isEmpty {
            filteredLearners = learners
        } else {
            filteredLearners = learners.filter { learner in
                learner.username.lowercased().contains(searchText.lowercased()) ||
                learner.topic.lowercased().contains(searchText.lowercased())
            }
        }
    }
}

