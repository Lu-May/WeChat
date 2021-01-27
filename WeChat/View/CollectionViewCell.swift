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
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(with img: String) {
    let Imgurl = URL(string: img)
    guard let url = Imgurl else {
      return
    }
    image.setImage(withURL: url)
  }

  override func prepareForReuse() {
     super.prepareForReuse()

     image.af.cancelImageRequest()
     image.image = nil
  }
}
