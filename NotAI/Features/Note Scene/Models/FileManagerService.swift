//
//  FileManagerService.swift
//  NotAI
//
//  Created by Samed Karakuş on 19.12.2024.
//

import UIKit
import PDFKit

class FileManagerService {
    
    static let shared = FileManagerService()
    
    private init() {}
    
    func extractTextFromPDF(url: URL) -> String? {
        if let pdfDocument = PDFDocument(url: url) {
            var fullText = ""
            for pageIndex in 0..<pdfDocument.pageCount {
                if let page = pdfDocument.page(at: pageIndex) {
                    if let pageContent = page.string {
                        fullText += pageContent
                    }
                }
            }
            return fullText
        } else {
            return nil
        }
    }
    
    func extractTextFromImage(image: UIImage, completion: @escaping (String?) -> Void) {
        TextRecognitionService.recognizeText(in: image) { recognizedText in
            completion(recognizedText)
        }
    }
}
