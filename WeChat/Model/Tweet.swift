//
//  Tweet.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/25.
//

import Foundation

struct Sender: Codable {
  var username: String
  var nick: String
  var avatar: String
}

struct Image: Codable {
  var url: String
}

struct Tweet: Codable {
  var content: String?
  var sender: Sender?
  var images: [Image]?
}
