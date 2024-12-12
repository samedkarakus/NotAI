//
//  QuizBrain.swift
//  NotAI
//
//  Created by Samed Karakuş on 23.10.2024.
//

import Foundation

class QuizViewModel {
    private var questions: [Question]
    private var currentIndex: Int = 0
    var score: Int = 0

    var currentQuestion: Question {
        return questions[currentIndex]
    }

    var questionNumber: Int {
        return currentIndex + 1
    }

    init(questions: [Question]) {
        self.questions = questions
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
}
