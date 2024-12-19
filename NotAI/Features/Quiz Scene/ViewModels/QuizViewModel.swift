//
//  QuizBrain.swift
//  NotAI
//
//  Created by Samed Karakuş on 23.10.2024.
//

import Foundation

class QuizViewModel {
    private var questions: [Question] = []
    private var currentIndex: Int = 0
    private(set) var score: Int = 0

    
    init() {
        questions = [
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
    
    var currentQuestion: Question {
        return questions[currentIndex]
    }

    var questionNumber: Int {
        return currentIndex + 1
    }

    var totalQuestions: Int {
        return questions.count
    }

    func checkAnswer(_ answer: String) -> Bool {
        let isCorrect = currentQuestion.correctAnswer == answer
        if isCorrect { score += 1 }
        return isCorrect
    }

    func nextQuestion() -> Bool {
        if currentIndex + 1 < questions.count {
            currentIndex += 1
            return true
        } else {
            return false
        }
    }

    func resetQuiz() {
        currentIndex = 0
        score = 0
    }
}
