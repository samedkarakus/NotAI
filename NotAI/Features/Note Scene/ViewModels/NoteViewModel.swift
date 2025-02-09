//
//  NoteViewModel.swift
//  NotAI
//
//  Created by Samed Karakuş on 28.11.2024.
//

import Foundation
import UIKit

class NoteViewModel {
    
    private var note: Note?
    private let fileManagerService = FileManagerService.shared
    private let textRecognitionService = TextRecognitionService.self
    
    var onTextUpdate: ((String) -> Void)?
    
    var title: String {
        return note?.title ?? ""
    }
    
    var body: String {
        return note?.body ?? ""
    }
    
    var createdDate: Date {
        return note?.createdDate ?? Date()
    }
    
    init(note: Note? = nil) {
        if let note = note {
            self.note = note
        } else {
            self.note = Note(id: "", title: "", body: "", createdDate: Date())
        }
    }
    
    func saveNote(title: String, body: String) {
        self.note?.title = title
        self.note?.body = body
    }
    
    func loadNote() -> Note? {
        return note
    }
    
    func processImage(image: UIImage) {
        fileManagerService.extractTextFromImage(image: image) { [weak self] text, processingTime in
            guard let text = text else { return }
            self?.onTextUpdate?(text)
        }
    }
    
    func processPDF(url: URL) {
        if let text = fileManagerService.extractTextFromPDF(url: url) {
            onTextUpdate?(text)
        }
    }
}
