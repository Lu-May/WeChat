//
//  TableViewCell.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/26.
//

import UIKit
import AlamofireImage

class TableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
  @IBOutlet weak var avatarImage: UIImageView!
  @IBOutlet weak var usernameLable: UILabel!
  @IBOutlet weak var contentLable: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var tweet: Tweet?
  
  private lazy var collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 0)
  
  func configure(with tweet: Tweet) {
    self.tweet = tweet
    usernameLable.text = tweet.sender?.nick ?? ""
    contentLable.text = tweet.content ?? ""
    if tweet.sender?.avatar != nil {
      let url = (URL(string: tweet.sender?.avatar ?? ""))!
      avatarImage.setImage(withURL: url)
    }
    
    if tweet.images == nil || tweet.images?.count == 0 {
      collectionViewHeightConstraint.constant = 0
    } else {
      
      collectionViewHeightConstraint.constant = 100
    }
    collectionView.reloadData()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.collectionView.delegate =  self
    self.collectionView.dataSource =  self
    collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionViewHeightConstraint.isActive = true
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let image = tweet?.images else {
      return 0
    }
    return image.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    let data = tweet?.images![indexPath.row]
    cell.configure(with: data?.url ?? "")
    return cell
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    
    avatarImage.af.cancelImageRequest()
    avatarImage.image = nil
  }
}

extension TableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    indexPath.
    return CGSize(width: 100, height: 100)
  }
}
