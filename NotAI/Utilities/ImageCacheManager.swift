//
//  ImageCacheManager.swift
//  NotAI
//
//  Created by Samed Karakuş on 26.01.2025.
//

import UIKit

class ImageCacheManager {
    static let shared = ImageCacheManager()
    private var cache = NSCache<NSString, UIImage>()

    private init() {}

    func getCachedImage(named name: String) -> UIImage? {
        if let cachedImage = cache.object(forKey: name as NSString) {
            return cachedImage
        } else {
            let image = UIImage(named: name)
            if let image = image {
                cache.setObject(image, forKey: name as NSString)
            }
            return image
        }
    }
}

