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

struct User: Codable {
    let info: UserInfo
    let notes: [UserNote]
}

struct UserInfo: Codable {
    let userId: String
    let userName: String
    let email: String
    let name: String
    let streak: String
}

struct UserNote: Codable {
    let noteId: String
    let title: String
    let text: String
    let lastUpdate: String
}

func sendChatGPTRequest(prompt: String, completion: @escaping (String?) -> Void) {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    let messages = [Message(role: "user", content: prompt)]
    let requestPayload = ChatGPTRequest(model: "gpt-4o-mini", messages: messages)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
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

func callChatGPTAPIForQuestionGeneration(with input: String, completion: @escaping (String) -> Void) {
    let url = URL(string: "https://api.openai.com/v1/chat/completions")!
    
    let dersNotlari = input
    let parameters: [String: Any] = [
        "model": "gpt-3.5-turbo",
        "messages": [
            [
                "role": "user",
                "content": """
                \(dersNotlari)
                Bu ders notlarını sana aşağıda verdiğim kriterlere göre işle.

                struct Question: Codable {
                    var question: String
                    var answer: [String]
                    var correctAnswer: String
                }
                ve
                var questions: [Question] = [] oldugunu bil. 
                Ders Notlarını kullanarak yukarıdaki kurallara uygun ve aşağıdaki örnek formata göre bana 10 adet soru hazırla. Bana yollayacağın çıktı sadece aşağıdaki formatta dönen bir JSON dizisi olsun. Ekstra açıklama, başlık ya da yorum ekleme. Sorular birbirinden ve aşağıdakilerden farklı olsun.
                questions = [
                            Question(
                                question: "Aşağıdakilerden hangisi bir sözleşmenin 'geçersiz' olmasına sebep olabilir?",
                                answer: ["Sözleşmenin yazılı yapılması.", "Taraflardan birinin ehliyetsiz olması.", "Sözleşmenin noter huzurunda yapılması.", "Tarafların mutabakata varması."],
                                correctAnswer: "Taraflardan birinin ehliyetsiz olması."
                            ),
                            Question(
                                question: "Aşağıdakilerden hangisi medeni hukukun dallarından biridir?",
                                answer: ["Ceza hukuku.", "Vergi hukuku.", "Aile hukuku.", "İdari hukuk."],
                                correctAnswer: "Aile hukuku."
                            )
                ]
                """
            ]
        ],
        "temperature": 0.6
    ]
    
    let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("Bearer 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", forHTTPHeaderField: "Authorization")
    request.httpBody = jsonData
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Hata: \(error.localizedDescription)")
            completion("Bir hata oluştu.")
            return
        }
        
        guard let data = data else {
            print("Veri alınamadı.")
            completion("Bir hata oluştu.")
            return
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
            if let content = decodedResponse.choices.first?.message.content {
                completion(content)
            } else {
                print("Mesaj bulunamadı.")
                completion("Bir hata oluştu.")
            }
        } catch {
            print("JSON çözümleme hatası: \(error)")
            completion("Bir hata oluştu.")
        }
    }
    
    task.resume()
}


