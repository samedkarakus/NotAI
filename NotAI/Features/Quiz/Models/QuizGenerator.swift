//
//  QuizGenerator.swift
//  NotAI
//
//  Created by Samed Karakuş on 29.11.2024.
//

import Foundation

class QuizGenerator {
    func fetchQuestions() -> [Question] {
        return [
            Question(
                question: "Aşağıdakilerden hangisi bir sözleşmenin 'geçersiz' olmasına sebep olabilir?",
                answer: ["Sözleşmenin yazılı yapılması.", "Taraflardan birinin ehliyetsiz olması.", "Sözleşmenin noter huzurunda yapılması.", "Tarafların mutabakata varması."],
                correctAnswer: "Taraflardan birinin ehliyetsiz olması."
            ),
            Question(
                question: "Aşağıdakilerden hangisi medeni hukukun dallarından biridir?",
                answer: ["Ceza hukuku.", "Vergi hukuku.", "Aile hukuku.", "İdari hukuk."],
                correctAnswer: "Aile hukuku."
            ),
            Question(
                question: "Hangi durumda bir davranış 'objektif sorumluluk' kapsamında değerlendirilebilir?",
                answer: ["Kusurlu bir davranış olmaksızın zarar meydana gelmişse.", "Zarar kasıtlı bir davranış sonucunda ortaya çıkmışsa.", "Bir borcun ifasında temerrüde düşülmüşse.", "Taraflar arasında sözleşme yapılmışsa."],
                correctAnswer: "Kusurlu bir davranış olmaksızın zarar meydana gelmişse."
            ),
            Question(
                question: "Aşağıdaki unsurlardan hangisi 'haksız zenginleşme' için gereklidir?",
                answer: ["Zarar verenin kusurlu olması.", "Zenginleşmenin bir başkasının zararına olması.", "Taraflar arasında sözleşme bulunması.", "Hukuka uygun bir davranış olması."],
                correctAnswer: "Zenginleşmenin bir başkasının zararına olması."
            ),
            Question(
                question: "Aşağıdakilerden hangisi ceza hukuku açısından bir 'kasten öldürme' suçunun unsurlarındandır?",
                answer: ["Fiilin mağdura zarar vermemiş olması.", "Fiilin hukuka uygun bir gerekçe ile işlenmesi.", "Fiilin kasıtlı olarak işlenmesi.", "Fiilin bir sözleşmeye dayalı olması."],
                correctAnswer: "Fiilin kasıtlı olarak işlenmesi."
            ),
            Question(
                question: "Aşağıdakilerden hangisi 'borçlar hukuku'nda borcun sona erme sebeplerinden biridir?",
                answer: ["Kusurlu davranış.", "Borçlunun ödeme yapması.", "Tazminat yükümlülüğü.", "Mahkeme kararıyla borcun artırılması."],
                correctAnswer: "Borçlunun ödeme yapması."
            ),
            Question(
                question: "Aşağıdakilerden hangisi 'kişilik hakları'nın ihlali sayılmaz?",
                answer: ["Bir kişinin özel hayatına izinsiz girilmesi.", "Kişinin itibarını zedeleyen yalan haber yapılması.", "Kişinin maddi varlığına zarar verilmesi.", "Bir kişinin medeni halinin doğru şekilde açıklanması."],
                correctAnswer: "Bir kişinin medeni halinin doğru şekilde açıklanması."
            ),
            Question(
                question: "Aşağıdakilerden hangisi bir 'taşınır mal'ın özelliklerinden biridir?",
                answer: ["Yer değiştirebilen mallardır.", "Mülkiyet hakkı yalnızca noter onayı ile devredilebilir.", "Zorunlu sigorta gerektirir.", "Bir arazi ya da bina örnek olarak gösterilebilir."],
                correctAnswer: "Yer değiştirebilen mallardır."
            ),
            Question(
                question: "Aşağıdakilerden hangisi bir 'temyiz kudreti'ne sahip olmanın koşullarından biri değildir?",
                answer: ["Kişinin reşit olması.", "Fiilin sonuçlarını anlayabilecek durumda olması.", "Akıl sağlığının yerinde olması.", "Kişinin mal varlığına sahip olması."],
                correctAnswer: "Kişinin mal varlığına sahip olması."
            ),
            Question(
                question: "Aşağıdakilerden hangisi 'haklı fesih' sebeplerinden biridir?",
                answer: ["Taraflardan birinin kendi isteğiyle sözleşmeden çekilmesi.", "Sözleşmenin süresinin dolması.", "Karşı tarafın yükümlülüklerini ağır şekilde ihlal etmesi.", "Sözleşmenin noter huzurunda yapılmaması."],
                correctAnswer: "Karşı tarafın yükümlülüklerini ağır şekilde ihlal etmesi."
            )
        ]
    }
}
