//
//  TextRecognitionHelper.swift
//  zap
//
//  Created by Samed Karakuş on 17.10.2024.
//

import UIKit
import Vision

class TextRecognitionHelper {

    static func recognizeText(in image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage)

        let request = VNRecognizeTextRequest { request, error in
            guard let results = request.results as? [VNRecognizedTextObservation],
            error == nil else {
                completion(nil)
                return
            }
            let recognizedText = results.compactMap {
                $0.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            DispatchQueue.main.async {
                completion(recognizedText)
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    completion(nil)
                }
                print("Error: \(error)")
            }
        }
    }
}

