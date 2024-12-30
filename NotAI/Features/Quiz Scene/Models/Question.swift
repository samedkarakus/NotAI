//
//  Question.swift
//  NotAI
//
//  Created by Samed Karakuş on 20.10.2024.
//

import Foundation

struct Question: Codable {
    var question: String
    var answer: [String]
    var correctAnswer: String
}

var questions: [Question] = []
var score: Int = 0
