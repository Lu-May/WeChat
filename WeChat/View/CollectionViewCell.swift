//
//  CollectionViewCell.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/26.
//

import UIKit
import AlamofireImage

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var image:UIImageView!
  let imageCache = ImageCache()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(with img: String) {
    ImageCache.shared.getImageFromCache(img) { [weak self] img, _ in
      self?.image.image = img
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    image.image = nil
  }
}
