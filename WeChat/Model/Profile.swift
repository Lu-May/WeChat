//
//  Profile.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/26.
//

import Foundation

struct Profile: Codable {
  var profile_image: String
  var avatar: String
  var nick: String
  var username: String
  
  enum CodingKeys: String, CodingKey {
    case profile_image = "profile-image"
    case avatar
    case nick
    case username
  }
}


