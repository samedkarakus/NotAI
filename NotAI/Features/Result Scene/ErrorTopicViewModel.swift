//
//  ErrorTopicViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 24.12.2024.
//

import Foundation

class ErrorTopicViewModel {
    var errors: [ErrorTopic] = [
        ErrorTopic(topicTitle: "Ehliyetsizlik Yanılgısı", topicDescription: "Sözleşmenin geçersizliği için taraflardan birinin ehliyetsiz olması gereklidir."),
        ErrorTopic(topicTitle: "Medeni Hukuk Yanılgısı", topicDescription: "Aile hukuku, medeni hukukun bir dalıdır; diğer seçenekler değildir."),
        ErrorTopic(topicTitle: "Objektif Sorumluluk Yanılgısı", topicDescription: "Objektif sorumluluk, kusursuz davranışla zarar meydana geldiğinde söz konusudur."),
        ErrorTopic(topicTitle: "Haksız Zenginleşme Unsuru", topicDescription: "Haksız zenginleşme, başkasının zararına bir zenginleşme olduğunda oluşur."),
        ErrorTopic(topicTitle: "Kasten Öldürme Unsuru", topicDescription: "Kasten öldürme, kasıtlı bir fiil gerektirir; hukuka uygunluk unsuru değildir."),
        ErrorTopic(topicTitle: "Borcun Sona Erme Sebebi", topicDescription: "Borcun sona ermesi, borçlunun ödeme yapmasıyla gerçekleşir; kusurlu davranışla değil."),
        ErrorTopic(topicTitle: "Kişilik Hakları İhlali Yanılgısı", topicDescription: "Bir kişinin medeni halinin doğru açıklanması kişilik hakkı ihlali değildir."),
        ErrorTopic(topicTitle: "Taşınır Mal Tanımı", topicDescription: "Taşınır mallar yer değiştirebilen mallardır; arazi veya bina taşınmazdır."),
        ErrorTopic(topicTitle: "Temyiz Kudreti Koşulu", topicDescription: "Mal varlığı, temyiz kudreti için bir koşul değildir; reşitlik ve akıl sağlığı önemlidir."),
        ErrorTopic(topicTitle: "Haklı Fesih Yanılgısı", topicDescription: "Haklı fesih, karşı tarafın yükümlülüklerini ağır şekilde ihlal etmesi durumunda mümkündür.")
    ]
}

