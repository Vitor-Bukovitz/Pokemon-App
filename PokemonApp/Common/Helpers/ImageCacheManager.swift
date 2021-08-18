//
//  ImageCacheManager.swift
//  PokemonApp
//
//  Created by PremierSoft on 17/08/21.
//

import UIKit

class ImageCacheManager {
    
    let cache = NSCache<NSString, UIImage>()
    static let shared = ImageCacheManager()
    
    func downloadImage(with link: String, completion: @escaping ((UIImage?) -> Void) ) {
        let cacheKey = NSString(string: link)
        if let image = cache.object(forKey: cacheKey) {
            return completion(image)
        }
        guard let url = URL(string: link) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return completion(nil) }
            guard let data = data else { return completion(nil) }
            guard let image = UIImage(data: data) else { return completion(nil) }
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }.resume()
    }
}
