//
//  CollectionViewCell.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/26.
//

import UIKit
import AlamofireImage

class TweetImageCell: UICollectionViewCell {
  @IBOutlet weak var image:UIImageView!
  let imageCache = ImageCache()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(with img: String) {
    image.setImage(withURL: img)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    image.image = nil
  }
}
