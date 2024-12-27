//
//  TextRecognitionService.swift
//  NotAI
//
//  Created by Samed Karakuş on 19.12.2024.
//

import UIKit
import Vision

class TextRecognitionService {
    
    static func performOCRWithVision(in image: UIImage, completion: @escaping (String?, TimeInterval?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil, nil)
            return
        }
        
        let startTime = Date()
        
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                print("Metin tanıma hatası: \(error.localizedDescription)")
                completion(nil, nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil, nil)
                return
            }
            
            let recognizedText = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: " ")
            
            let endTime = Date()
            let processingTime = endTime.timeIntervalSince(startTime)
            
            print("OCR İşlem Süresi: \(processingTime) saniye")
            
            completion(recognizedText, processingTime)
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try? requestHandler.perform([request])
    }
}


