//
//  QuizGenerator.swift
//  zap
//
//  Created by Samed Karakuş on 15.11.2024.
//


import Foundation

class QuizGenerator {
    
    func createQuizQuestion(from notes: String, completion: @escaping (String?, [String]?, String?) -> Void) {
        guard let url = URL(string: Constants.apiURL) else {
            completion(nil, nil, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(Constants.apiKey)", forHTTPHeaderField: "Authorization")

        let messages = [
            [
                "role": "system",
                "content": "You are a helpful AI that generates quiz questions with one correct answer and three incorrect answers."
            ],
            [
                "role": "user",
                "content": """
                Create a multiple-choice question from these notes: "\(notes)". 
                The response should include:
                - A single question,
                - Four answer options,
                - Indicate which answer is correct.
                """
            ]
        ]

        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": messages,
            "max_tokens": 150,
            "temperature": 0.7
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, nil, nil)
                return
            }

            if let responseJSON = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = responseJSON["choices"] as? [[String: Any]],
               let message = choices.first?["message"] as? [String: Any],
               let content = message["content"] as? String {
                
                let lines = content.components(separatedBy: "\n")
                let question = lines.first
                let answers = Array(lines.dropFirst().prefix(4))
                let correctAnswer = answers.first
                
                // Soruları dosyaya kaydet
                self.saveQuestionsToFile(questions: [
                    Question(question: question ?? "", answer: answers, correctAnswer: correctAnswer ?? "")
                ])
                
                completion(question, answers, correctAnswer)
            } else {
                completion(nil, nil, nil)
            }
        }
        task.resume()
    }
    
    private func saveQuestionsToFile(questions: [Question]) {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentDirectory.appendingPathComponent("quizQuestions.json")

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(questions)  // Burada artık 'Question' modelini encode edebiliriz
            try data.write(to: fileURL)
            print("Sorular başarıyla dosyaya kaydedildi.")
        } catch {
            print("Dosyaya yazarken hata oluştu: \(error)")
        }
    }

}
