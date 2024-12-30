//
//  APIClient.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation

struct ChatGPTRequest: Encodable {
    let model: String
    let messages: [Message]
}

struct Message: Encodable {
    let role: String
    let content: String
}

struct ChatGPTResponse: Decodable {
    let choices: [Choice]
}

struct Choice: Decodable {
    let message: MessageContent
}

struct MessageContent: Decodable {
    let role: String
    let content: String
}

func sendChatGPTRequest(prompt: String, completion: @escaping (String?) -> Void) {
    let apiKey = "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"
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    let messages = [Message(role: "user", content: prompt)]
    let requestPayload = ChatGPTRequest(model: "gpt-4o-mini", messages: messages)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        let jsonData = try JSONEncoder().encode(requestPayload)
        request.httpBody = jsonData
    } catch {
        print("Error encoding JSON: \(error)")
        completion(nil)
        return
    }
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Request error: \(error)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
            let reply = decodedResponse.choices.first?.message.content
            completion(reply)
        } catch {
            print("Error decoding JSON: \(error)")
            completion(nil)
        }
    }
    
    task.resume()
}

