//
//  TableViewHeader.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/26.
//

import UIKit

class TweetsHeader: UITableViewHeaderFooterView {
  @IBOutlet weak var profile_image: UIImageView?
  @IBOutlet weak var avatar: UIImageView?
  @IBOutlet weak var nick: UILabel?
  
  let imageCache = ImageCache()
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(with profile: Profile) {
    profile_image?.setImage(withURL: profile.profileImage)
    avatar?.setImage(withURL: profile.avatar)
    nick?.font = UIFont(name: "Helvetica-Bold", size: 18)
    nick?.text = profile.nick
  }
}
