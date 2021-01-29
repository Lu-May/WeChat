//
//  TableViewHeader.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/26.
//

import UIKit

class TableViewHeader: UITableViewHeaderFooterView {
  @IBOutlet weak var profile_image: UIImageView?
  @IBOutlet weak var avatar: UIImageView?
  @IBOutlet weak var nick: UILabel?
  
  let imageCache = ImageCache()
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(with profile: Profile) {
    
    ImageCache.shared.getImageFromCache(profile.profileImage) { [weak self] image, _ in
      self?.profile_image?.image = image
    }
    
    ImageCache.shared.getImageFromCache(profile.avatar) { [weak self] image, _ in
      self?.avatar?.image = image
    }
    nick?.font = UIFont(name: "Helvetica-Bold", size: 18)
    nick?.text = profile.nick
  }
}
