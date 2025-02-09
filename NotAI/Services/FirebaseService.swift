//
//  FirebaseService.swift
//  NotAI
//
//  Created by Samed Karakuş on 11.01.2025.
//

import Firebase

class FirebaseService {

    private let db = Database.database().reference()

    func addNewNote(title: String, body: String, completion: @escaping (Bool, Error?) -> Void) {
        guard let userEmail = Auth.auth().currentUser?.email else {
            print("User is not logged in")
            completion(false, nil)
            return
        }

        let userID = UUID().uuidString
        let noteID = UUID().uuidString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let lastUpdateString = dateFormatter.string(from: Date())

        let newNote: [String: Any] = [
            "noteID": noteID,
            "title": title,
            "content": body,
            "lastUpdate": lastUpdateString
        ]

        let userUpdates: [String: Any] = [
            "user_\(userID)/email": userEmail,
            "user_\(userID)/notes/\(noteID)": newNote
        ]
        
        db.child("users").updateChildValues(userUpdates) { error, _ in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
}
