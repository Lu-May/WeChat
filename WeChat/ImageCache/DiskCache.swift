//
//  DiskCache.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/2/1.
//

import Foundation
import UIKit

class DiskCache {
  lazy var fileManager = FileManager.default
  static let shared = DiskCache()
  private let imageNetworkClient: ImageNetworkClient = .init()
  lazy var documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
  
  lazy var documentPath = documentsURL.path
  
  private func getPath(url: String) -> String {
    let array = url.split(separator: "/")
    let pathString = array[array.count - 2] + array[array.count - 1]
    return String(pathString)
  }
  
  func saveImage(url: String, image: UIImage){
    
    let pathString = getPath(url: url)
    let filePath = documentsURL.appendingPathComponent("\(pathString)")
    
    do {
      try self.fileManager.createDirectory(atPath: String(documentPath), withIntermediateDirectories: true, attributes: nil)
      if let pngImageData = image.pngData() {
        try pngImageData.write(to: filePath, options: .atomic)
      }
    } catch {
      print(error)
    }
  }
  
  func getImage(url: String) -> UIImage? {
    let pathString = getPath(url: url)
    let filePath = documentsURL.appendingPathComponent("\(pathString)")
    
    return UIImage(contentsOfFile: filePath.path)
  }
}
