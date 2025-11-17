//
//  ImageLoader.swift
//  PlatePilot
//
//  Created on 2025-11-17.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    private let session: URLSession
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
        
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: configuration)
    }
    
    /// Load an image from URL with caching
    /// - Parameters:
    ///   - urlString: The URL string of the image
    ///   - completion: Callback with optional UIImage
    func loadImage(from urlString: String?, completion: @escaping (UIImage?) -> Void) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        // Check cache first
        if let cachedImage = cache.object(forKey: url as NSURL) {
            completion(cachedImage)
            return
        }
        
        // Download image
        let task = session.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data,
                  error == nil,
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Cache the image
            self?.cache.setObject(image, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
        task.resume()
    }
    
    /// Clear the image cache
    func clearCache() {
        cache.removeAllObjects()
    }
}

// MARK: - UIImageView Extension

extension UIImageView {
    
    /// Load and set image from URL with a placeholder
    /// - Parameters:
    ///   - urlString: The URL string of the image
    ///   - placeholder: Optional placeholder image to show while loading
    func loadImage(from urlString: String?, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        ImageLoader.shared.loadImage(from: urlString) { [weak self] image in
            self?.image = image ?? placeholder
        }
    }
}
