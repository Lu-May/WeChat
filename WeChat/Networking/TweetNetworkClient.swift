//
//  NetworkClient.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/25.
//

import Foundation
import Alamofire

struct TweetNetworkClient {
  func request(url: URL, completion: @escaping (Any?, Error?) -> Void) {
    AF.request(url).validate().responseJSON { dataResponse in
      switch dataResponse.result {
      case .success(_):
        var tweetDatas: [Tweet] = []
        do {
          tweetDatas = try JSONDecoder().decode([Tweet].self, from: dataResponse.data!)
        } catch {
          print(error)
        }
        completion(tweetDatas, nil)
      case let .failure(error):
        completion(nil, error)
      }
    }
  }
}
