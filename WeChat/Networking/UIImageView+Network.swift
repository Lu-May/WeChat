//
//  UIImageViewNetworking.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/25.
//

import UIKit

extension UIImageView {
  func setImage(withURL url: String) {
    ImageCache.shared.getImageFromCache(url) { image in
      self.image = image
    }
  }
}

