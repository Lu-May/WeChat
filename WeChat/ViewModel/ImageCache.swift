//
//  ImageCache.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/29.
//

import Foundation
import UIKit

class ImageCache {
  var cache = NSCache<NSString, UIImage>()
  static let shared = ImageCache()
  
  private let imageNetworkClient: ImageNetworkClient = .init()
  
  func getImageFromCache(_ url: String, completion: @escaping (UIImage?, Error?) -> Void) {
    if let image = cache.object(forKey: url as NSString) {
      completion(image, nil)
    } else {
      imageNetworkClient.request(url: URL(string: url)!) { data, _ in
        self.insertImageIntoCache(url, data as! UIImage)
        DispatchQueue.main.async {
          completion(data as? UIImage, nil)
        }
      }
    }
  }
  
  func insertImageIntoCache(_ url: String, _ image: UIImage) {
    cache.setObject(image, forKey: url as NSString)
  }
}

