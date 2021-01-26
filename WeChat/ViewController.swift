//
//  ViewController.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/25.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView?

  var dataSource: [Tweet]?

  private let networkClient: NetworkClient = .init()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    networkClient.request(url: URL(string: "https://emagrorrim.github.io/mock-api/moments.json")!){ json, _ in
      self.dataSource = json as? [Tweet]
      self.dataSource = self.dataSource?.filter( { $0.images != nil || $0.content != nil } )
      self.tableView?.reloadData()
    }
    tableView?.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.estimatedRowHeight = UITableView.automaticDimension
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if (dataSource != nil) {
      return dataSource?.count ?? 0
    }
    return 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
      return UITableViewCell()
    }
    cell.configure(with: dataSource?[indexPath.row] ?? Tweet())
    return cell
  }
}

