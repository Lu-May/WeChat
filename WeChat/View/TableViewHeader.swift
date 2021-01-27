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
  
  override class func awakeFromNib() {
    super.awakeFromNib()
  }
  
  func configure(with profile: Profile) {
    let profile_imageURL = URL(string: profile.profileImage)
    guard let url = profile_imageURL else {
      return
    }
    profile_image?.setImage(withURL: url)
    
    let avatarURL = URL(string: profile.avatar)
    guard let avatarUrl = avatarURL else {
      return
    }
    avatar?.setImage(withURL: avatarUrl)
    nick?.font = UIFont(name: "Helvetica-Bold", size: 18)
    nick?.text = profile.nick
  }
}
