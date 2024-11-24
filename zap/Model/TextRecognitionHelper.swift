//
//  TextRecognitionHelper.swift
//  zap
//
//  Created by Samed Karakuş on 17.10.2024.
//

import UIKit
import Vision

class TextRecognitionHelper: NoteViewController {

    static func recognizeText(in image: UIImage, textTo view: UITextView) {
        guard let cgImage = image.cgImage else {
            return
        }
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage)
        
        let request = VNRecognizeTextRequest { request, error in
            guard let results = request.results as? [VNRecognizedTextObservation],
            error == nil else {
                return
            }
            let string = results.compactMap {
                $0.topCandidates(1).first?.string
            }.joined(separator: "\n")
            DispatchQueue.main.async {
                view.text = string
            }
            print(string)
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform([request])
            } catch {
                print("Error: \(error)")
            }
        }
    }
}

