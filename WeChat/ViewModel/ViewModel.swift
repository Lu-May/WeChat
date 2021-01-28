//
//  ViewModel.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/28.
//

import Foundation

class ViewModel {
  var tweetDatas: [Tweet]?
  var tableViewDatas = [Tweet]()
  var profile: Profile?

  private let tweetNetworkClient: TweetNetworkClient = .init()
  private let profileNetworkClient: ProfileNetworkClient = .init()
  
  func getTweetDatas(completion: @escaping () -> Void) {
    tweetNetworkClient.request(url: URL(string: "https://emagrorrim.github.io/mock-api/moments.json")!){ json, _ in
      self.tweetDatas = json as? [Tweet]
      self.tweetDatas = self.tweetDatas?.filter( { $0.images != nil || $0.content != nil } )
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
    self.tweetDatas = tableViewDatas
    tableViewDatas = []
  }
  
  func getTableViewDataSource() {
    if tweetDatas?.count ?? 0 / 5 > 0 {
      for var i in 0..<5 {
        i += 1
        tableViewDatas.append(tweetDatas?.first ?? Tweet())
        tweetDatas?.removeFirst()
      }
    } else if tweetDatas?.count ?? 0 / 5 == 0 {
      if let datas = tweetDatas {
        for data in datas {
          tableViewDatas.append(data)
        }
        tweetDatas = []
      }
    }
  }
}
