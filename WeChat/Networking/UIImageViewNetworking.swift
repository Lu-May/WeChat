//
//  UIImageViewNetworking.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/25.
//

import UIKit
import AlamofireImage

extension UIImageView {
  func setImage(withURL url: URL) {
    self.af.setImage(withURL: url)
  }
}

