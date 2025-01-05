//
//  ErrorTopicViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 24.12.2024.
//

import Foundation

class ErrorTopicViewModel {
    var errors: [ErrorTopic] = [
        ErrorTopic(topicTitle: "Mertebe Tanımı Hatası", topicDescription: "Diferansiyel denklemin mertebesi, en yüksek türevin derecesiyle belirlenir."),
        ErrorTopic(topicTitle: "Homojen Denklem Yanılgısı", topicDescription: "Homojen diferansiyel denklemler, sağ tarafı sıfır olan denklemlerdir."),
        ErrorTopic(topicTitle: "Doğrusal Denklem Kavramı", topicDescription: "Doğrusal denklemler, yalnızca fonksiyon ve türevlerinin birinci dereceden terimlerini içerir."),
        ErrorTopic(topicTitle: "Değişken Ayrılması Kullanımı", topicDescription: "Değişken ayrılması yöntemi, yalnızca denklemin uygun şekilde ayrılabilir olması durumunda kullanılabilir."),
        ErrorTopic(topicTitle: "Laplace Dönüşümü Uygulaması", topicDescription: "Laplace dönüşümü, zaman alanındaki diferansiyel denklemleri daha kolay çözülebilir hale getirir."),
        ErrorTopic(topicTitle: "Karakteristik Denklem Yanılgısı", topicDescription: "Karakteristik denklemin kökleri doğru sınıflandırılmalıdır."),
        ErrorTopic(topicTitle: "Başlangıç Koşulları", topicDescription: "Diferansiyel denklemlerin tam çözümü için başlangıç ya da sınır koşulları doğru uygulanmalıdır."),
        ErrorTopic(topicTitle: "Partiküler Çözüm Yanılgısı", topicDescription: "Partiküler çözüm, özel yöntemlerle elde edilir; bu adım bazen eksik uygulanır."),
        ErrorTopic(topicTitle: "Genel Çözüm Tanımı", topicDescription: "Genel çözüm, homojen ve partiküler çözümlerin birleşimidir."),
        ErrorTopic(topicTitle: "İntegrasyon Faktörü Kullanımı", topicDescription: "İntegrasyon faktörü yöntemi, doğrusal diferansiyel denklemleri çözmek için kullanılır.")
    ]
}

