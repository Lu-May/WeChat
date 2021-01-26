//
//  ProfileNetworkClient.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/26.
//

import Foundation
import Alamofire

struct ProfileNetworkClient {
  func request(url: URL, completion: @escaping (Any?, Error?) -> Void) {
    AF.request(url).validate().responseJSON { dataResponse in
      switch dataResponse.result {
      case .success(_):
        var profileDatas: Profile?
        do {
          profileDatas = try JSONDecoder().decode(Profile.self, from: dataResponse.data!)
        } catch {
          print(error)
        }
        completion(profileDatas, nil)
      case let .failure(error):
        completion(nil, error)
      }
    }
  }
}
