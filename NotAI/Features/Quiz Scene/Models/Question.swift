//
//  Question.swift
//  NotAI
//
//  Created by Samed Karakuş on 20.10.2024.
//

import Foundation

struct Question: Codable {
    let question: String
    let answer: [String]
    let correctAnswer: String
}
