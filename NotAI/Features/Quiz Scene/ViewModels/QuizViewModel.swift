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
                question: "Birinci dereceden bir diferansiyel denklemin genel çözümü neyi ifade eder?",
                answer: ["Sabit bir çözüm kümesini.", "Bir dizi özel çözümü.", "Tüm olası çözümleri içeren ifadeyi.", "Yalnızca homojen çözümleri."],
                correctAnswer: "Tüm olası çözümleri içeren ifadeyi."
            ),
            Question(
                question: "Aşağıdaki denklemlerden hangisi bir diferansiyel denklem örneğidir?",
                answer: ["y = mx + b", "y' + y = 0", "x² + y² = r²", "a² + b² = c²"],
                correctAnswer: "y' + y = 0"
            ),
            Question(
                question: "Bir diferansiyel denklem 'homojen' olarak adlandırılabilmesi için hangi şart sağlanmalıdır?",
                answer: ["Tüm terimlerin aynı dereceye sahip olması.", "Denklemin bir sabit içermemesi.", "Denklemin türevsiz bir terim içermemesi.", "Tüm çözümlerin sıfır olması."],
                correctAnswer: "Tüm terimlerin aynı dereceye sahip olması."
            ),
            Question(
                question: "y' + p(x)y = q(x) biçimindeki diferansiyel denklem ne tür bir denklemdir?",
                answer: ["Doğrusal diferansiyel denklem.", "İkinci dereceden diferansiyel denklem.", "Homojen diferansiyel denklem.", "Karmaşık diferansiyel denklem."],
                correctAnswer: "Doğrusal diferansiyel denklem."
            ),
            Question(
                question: "Aşağıdaki yöntemlerden hangisi bir diferansiyel denklemin çözümünde kullanılmaz?",
                answer: ["Separation of variables.", "Integration by parts.", "Laplace transform.", "Gaussian elimination."],
                correctAnswer: "Gaussian elimination."
            ),
            Question(
                question: "İkinci dereceden homojen diferansiyel denklemlerde karakteristik köklerden biri reel, diğeri kompleks ise çözümün genel formu nasıldır?",
                answer: ["İki üstel terimin toplamı.", "Sinüs ve kosinüs terimlerinin kombinasyonu.", "Sabit bir değer.", "Doğrusal terimler içerir."],
                correctAnswer: "Sinüs ve kosinüs terimlerinin kombinasyonu."
            ),
            Question(
                question: "Bir diferansiyel denklemin 'özgün çözümü' ne anlama gelir?",
                answer: ["Sabit bir çözüm.", "Belirli başlangıç koşullarını sağlayan çözüm.", "Genel çözümün özel bir durumu.", "Türevsiz çözüm."],
                correctAnswer: "Belirli başlangıç koşullarını sağlayan çözüm."
            ),
            Question(
                question: "Birinci dereceden diferansiyel denklemler için 'ayrılabilir değişkenler' yöntemi hangi durumda uygulanabilir?",
                answer: ["Denklem doğrusal ise.", "Değişkenler çarpım biçiminde yazılabiliyorsa.", "Denklem ikinci dereceden ise.", "Denklem yalnızca sabit terimler içeriyorsa."],
                correctAnswer: "Değişkenler çarpım biçiminde yazılabiliyorsa."
            ),
            Question(
                question: "D'Alembert yöntemi hangi tür diferansiyel denklemleri çözmek için kullanılır?",
                answer: ["Doğrusal denklemler.", "Ayrılabilir denklemler.", "Homojen denklemler.", "İkinci dereceden doğrusal denklemler."],
                correctAnswer: "İkinci dereceden doğrusal denklemler."
            ),
            Question(
                question: "Bir diferansiyel denklemin çözümünde Laplace dönüşümü hangi avantajı sağlar?",
                answer: ["Denklemin çözümünü integral formuna çevirir.", "Başlangıç koşullarını doğrudan uygular.", "Çözümü yalnızca sinüs ve kosinüs terimlerine indirger.", "Denklemi matris formuna dönüştürür."],
                correctAnswer: "Başlangıç koşullarını doğrudan uygular."
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
