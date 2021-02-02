//
//  ViewModel.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/28.
//

import Foundation
import UIKit

class TweetsViewModel {
  var tweetDatas: [Tweet] = []
  var originalDatas: [Tweet] = []
  var tableViewDatas: [Tweet] = []
  var profile: Profile?
  
  private let tweetNetworkClient: TweetNetworkClient = .init()
  private let profileNetworkClient: ProfileNetworkClient = .init()
  
  func getTweetDatas(completion: @escaping () -> Void) {
    tweetNetworkClient.request(url: URL(string: "https://emagrorrim.github.io/mock-api/moments.json")!){ json, _ in
      guard let tweets = json as? [Tweet] else {
        return
      }
      self.tweetDatas = tweets
      self.tweetDatas = self.tweetDatas.filter( { $0.images != nil || $0.content != nil } )
      self.originalDatas = self.tweetDatas
      self.getTableViewDataSource()
      completion()
    }
  }
  
  func getProfiles(completion: @escaping () -> Void) {
    profileNetworkClient.request(url: URL(string: "https://emagrorrim.github.io/mock-api/user/jsmith.json")!) { json, _ in
      self.profile = json as? Profile
      completion()
    }
  }
  
  func initDatas() {
    self.tweetDatas = originalDatas
    tableViewDatas = []
  }
  
  func getTableViewDataSource() {
    if tweetDatas.count / 5 > 0 {
      for var i in 0..<5 {
        i += 1
        tableViewDatas.append(tweetDatas[0])
        tweetDatas.removeFirst()
      }
    } else if tweetDatas.count / 5 == 0 {
      for data in tweetDatas {
        tableViewDatas.append(data)
      }
      tweetDatas = []
    }
  }
}
