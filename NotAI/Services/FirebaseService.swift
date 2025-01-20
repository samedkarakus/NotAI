//
//  FirebaseService.swift
//  NotAI
//
//  Created by Samed Karakuş on 11.01.2025.
//

import FirebaseDatabase

class FirebaseService {
    func addUserToFirebase(note: Note, email: String, completion: @escaping (Bool) -> Void) {
        let databaseRef = Database.database().reference()
        let formattedDate = note.createdDate
        
        let usersRef = databaseRef.child("users")
        usersRef.observeSingleEvent(of: .value) { snapshot in
            let userCount = snapshot.childrenCount
            let userKey = "user\(userCount + 1)"
            let newUser: [String: Any] = [
                "info": ["userId": "\(userCount + 1)", "userName": "kullaniciadi", "email": email],
                "userNotes": [
                    "note1": ["notId": "1", "title": note.title, "text": note.body, "lastUpdate": formattedDate]
                ]
            ]
            
            usersRef.child(userKey).setValue(newUser) { error, _ in
                if let error = error {
                    print("Error adding user: \(error.localizedDescription)")
                    completion(false)
                } else {
                    print("User added successfully.")
                    completion(true)
                }
            }
        }
    }
}

