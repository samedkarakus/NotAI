//
//  ErrorTopic.swift
//  NotAI
//
//  Created by Samed Karakuş on 19.01.2025.
//

import Foundation

struct IncorrectQuestions: Codable {
    var question: String
    var userAnswer: String
    var correctAnswer: String
}

var incorrectAnsweredQuestions: [IncorrectQuestions] = []
