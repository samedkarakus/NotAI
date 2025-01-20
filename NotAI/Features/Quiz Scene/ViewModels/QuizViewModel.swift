//
//  QuizBrain.swift
//  NotAI
//
//  Created by Samed Karakuş on 23.10.2024.
//

import Foundation

class QuizViewModel {
    
    var currentIndex: Int = 0
    var incorrectAnswerwedQuestions: [IncorrectQuestions] = []

    func updateQuestions(with newQuestions: [Question]) {
        questions = newQuestions
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
        let pressedAnswer: String = answer
        if pressedAnswer == currentQuestion.correctAnswer {
            score += 1
            return true
        } else {
            let incorrectQuestion = IncorrectQuestions(
                question: currentQuestion.question,
                userAnswer: pressedAnswer,
                correctAnswer: currentQuestion.correctAnswer
            )
            incorrectAnsweredQuestions.append(incorrectQuestion)
            return false
        }
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
