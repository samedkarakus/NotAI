//
//  ErrorTopicViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 24.12.2024.
//


import Foundation

class IncorrectQuestionsViewModel {
    var incorrectAnsweredQuestions: [IncorrectQuestions] = []
    
    func addIncorrectQuestion(_ question: IncorrectQuestions) {
        incorrectAnsweredQuestions.append(question)
    }
    
    func getAllIncorrectQuestions() -> [IncorrectQuestions] {
        return incorrectAnsweredQuestions
    }
}
