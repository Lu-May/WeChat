//
//  MemoryCache.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/2/2.
//

import Foundation
import UIKit

class MemoryCache {
  static let shared = MemoryCache()
  var cache = NSCache<NSString, UIImage>()
  
  func getImage(url: String) -> UIImage? {
    return cache.object(forKey: url as NSString)
  }
  
  func saveImage(url: String, image: UIImage) {
    cache.setObject(image, forKey: url as NSString)
  }
}
