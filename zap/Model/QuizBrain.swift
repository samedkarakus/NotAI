//
//  QuizBrain.swift
//  zap
//
//  Created by Samed Karakuş on 23.10.2024.
//

import Foundation

struct QuizBrain {
    var questionNumber = 0
    var score = 0
    
    let quiz = [
        Question(question: "Aşağıdakilerden deneme hangisi haksız fiil hukukunda 'ihmal'e (kusurlu davranış) bir örnektir?", answer: ["Bir kişinin kasıtlı olarak başkasının malına zarar vermesi.", "Bir doktorun yanlış ilaç yazıp hastaya zarar vermesi.", "Bir şirketin bilerek sözleşmeyi ihlal etmesi.", "Bir kişinin delil olmadan hırsızlık suçuyla tutuklanması."], correctAnswer: "Bir doktorun yanlış ilaç yazıp hastaya zarar vermesi."
        ),
        
        Question(question: "Aşağıdakilerden hangisi bir 'idari işlem'in özelliklerinden biridir?", answer: ["Yalnızca özel kişiler arasında yapılan sözleşmelerdir.", "Kamu otoritesi tarafından yapılan tek taraflı işlemlerdir.", "Suç teşkil eden fiillerin yargılamasıdır.", "Mahkemeler tarafından verilen nihai kararlardır."], correctAnswer: "Kamu otoritesi tarafından yapılan tek taraflı işlemlerdir."
        ),
    ]
    
    func getQuestion() -> String {
        return quiz[questionNumber].question
    }
    
    func getAnswer() -> [String] {
        return quiz[questionNumber].answer
    }
    
    mutating func nextQuestion() {
        if questionNumber + 1 < quiz.count {
            questionNumber += 1
        } else {
            questionNumber = 0
            score = 0
        }
    }
    
    mutating func checkAnswer(_ userAnswer: String) -> Bool {
        if userAnswer == quiz[questionNumber].correctAnswer {
            score += 1
            return true
        } else {
            return false
        }
    }
}
