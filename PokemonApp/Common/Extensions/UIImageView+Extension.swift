//
//  UIImageView+Extension.swift
//  PokemonApp
//
//  Created by PremierSoft on 17/08/21.
//

import UIKit

extension UIImageView {
    
    func setRemoteImage(with url: String?) -> URLSessionDataTask? {
        guard let url = url else { return nil }
        return ImageCacheManager.shared.downloadImage(with: url) { [weak self] image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve) {
                    self.image = image
                }
            }
        }
    }
}
