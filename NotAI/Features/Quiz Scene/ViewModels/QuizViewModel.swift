//
//  QuizBrain.swift
//  NotAI
//
//  Created by Samed Karakuş on 23.10.2024.
//

import Foundation

class QuizViewModel {
    
    var currentIndex: Int = 0
    private(set) var score: Int = 0
    
    
    func updateQuestions(with newQuestions: [Question]) {
        for question in newQuestions {
            questions.append(question)  // Yeni soruyu diziye ekleriz
        }
        //print("Sorular güncellendi: \(questions)")
    }
    
    var currentQuestion: Question {
         questions[currentIndex]
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
