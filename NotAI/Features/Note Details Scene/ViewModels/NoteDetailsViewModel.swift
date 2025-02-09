//
//  NoteDetailsViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 1.01.2025.
//

import Foundation
import Firebase

class NoteDetailsViewModel {
    
    var notes: [Note] = []
    var filteredNotes: [Note] = []
    private let db = Firestore.firestore()
    let firebaseService = FirebaseService()
    
    func fetchNotes(for userID: String, completion: @escaping () -> Void) {
        db.collection("users").document(userID).collection("notes").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching notes: \(error.localizedDescription)")
                completion()
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion()
                return
            }
            
            self.notes = documents.compactMap { doc -> Note? in
                let data = doc.data()
                guard let title = data["title"] as? String,
                      let body = data["body"] as? String,
                      let timestamp = data["createdDate"] as? Timestamp else { return nil }
                return Note(id: doc.documentID, title: title, body: body, createdDate: timestamp.dateValue())
            }
            
            self.filteredNotes = self.notes
            completion()
        }
    }
    
    func deleteNoteFromFirebase(note: Note, for userID: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").document(userID).collection("notes").document(note.id).delete { error in
            if let error = error {
                print("Error deleting note: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Note deleted successfully")
                completion(true)
            }
        }
    }
    
    func filteredNotes(by searchText: String) {
        if searchText.isEmpty {
            filteredNotes = notes
        } else {
            filteredNotes = notes.filter { $0.title.lowercased().contains(searchText.lowercased()) || $0.body.lowercased().contains(searchText.lowercased()) }
        }
    }
}
