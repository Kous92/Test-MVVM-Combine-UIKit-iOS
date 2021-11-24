//
//  CachedImageView.swift
//  Test Combine
//
//  Created by Koussaïla Ben Mamar on 12/11/2021.
//

import UIKit

// MARK: - Une extension d'ImageView pour gérer le cache et le téléchargement asynchrone de l'image.
final class CachedImageView: UIImageView {
    private static let imageCache = NSCache<AnyObject, UIImage>()
    
    func loadImage(fromURL imageURL: URL) {
        // Image temporaire ou maintenue si l'image de l'URL est indisponible
        self.image = UIImage(named: "")
        
        if let cachedImage = CachedImageView.imageCache.object(forKey: imageURL as AnyObject) {
            self.image = cachedImage
            self.showLoading()
            return
        }
        
        // Le téléchargement et la mise à jour de l'image se fait de façon asynchrone
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: imageData) {
                    // Le changement d'image après téléchargement doit se faire dans le main thread
                    DispatchQueue.main.async {
                        self?.image = image
                        self?.stopLoading()
                    }
                }
            }
        }
    }
}
