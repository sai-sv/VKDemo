//
//  WebImageView.swift
//  VKDemo
//
//  Created by Admin on 29.12.2019.
//  Copyright © 2019 sergei. All rights reserved.
//

import Foundation
import UIKit

class WebImageView: UIImageView {
    
    func set(imageURL: String?) {
        
        guard let imageURL = imageURL, let url = URL(string: imageURL) else {
            self.image = nil
            return
        }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
            //print(#function + " load image from cache")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            if error != nil, let data = data, let response = response {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.image = image
                    self?.handleLoadedData(data: data, response: response)
                }
            }
        }.resume()
        
        /*do {
            let imageData = try Data(contentsOf: url)
            self.image = UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
        }*/
    }
    
    private func handleLoadedData(data: Data, response: URLResponse) {
        guard let url = response.url else { return }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: URLRequest(url: url))
    }
}
