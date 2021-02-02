//
//  ImageNetworkClient.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/29.
//

import Foundation
import Alamofire

struct ImageNetworkClient {
  func request(url: URL, completion: @escaping (UIImage?) -> Void) {
    AF.request(url).validate().responseData { dataResponse in
      switch dataResponse.result {
      case .success(_):
        var imageData: UIImage?
        imageData = UIImage(data: dataResponse.data!)
        completion(imageData)
      case .failure(_): break
      }
    }
  }
}
