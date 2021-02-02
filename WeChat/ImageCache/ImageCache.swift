//
//  ImageCache.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/29.
//

import Foundation
import UIKit

class ImageCache {
  static let shared = ImageCache()
  
  private let imageNetworkClient: ImageNetworkClient = .init()
  
  func getImageFromCache(_ url: String, completion: @escaping (UIImage) -> Void) {
    if let image = MemoryCache.shared.getImage(url: url) {
      completion(image)
    } else if let image = DiskCache.shared.getImage(url: url) {
      MemoryCache.shared.saveImage(url: url, image: image)
      completion(image)
    } else {
      guard let imageUrl = URL(string: url) else {
        return
      }
      
      imageNetworkClient.request(url: imageUrl) { image in
        MemoryCache.shared.saveImage(url: url, image: image)
        DiskCache.shared.saveImage(url: url, image: image)
        DispatchQueue.main.async {
          completion(image)
        }
      }
    }
  }
}

