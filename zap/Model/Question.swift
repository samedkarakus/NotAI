//
//  Question.swift
//  zap
//
//  Created by Samed Karakuş on 20.10.2024.
//

import Foundation

struct Question: Codable {
    let question: String
    let answer: [String]
    let correctAnswer: String
    
    init(question: String, answer: [String], correctAnswer: String) {
        self.question = question
        self.answer = answer
        self.correctAnswer = correctAnswer
    }
}
