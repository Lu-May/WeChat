//
//  ViewController.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/25.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  let viewModel = ViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "朋友圈"
        
    viewModel.getTweetDatas() { [weak self] in
      self?.tableView.reloadData()
    }

    let view = UIView()
    
    let header = Bundle.main.loadNibNamed("TableViewHeader", owner: nil, options: nil)?.first as! TableViewHeader
    view.addSubview(header)
    
    header.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      header.widthAnchor.constraint(equalToConstant: tableView.bounds.width),
      header.heightAnchor.constraint(equalToConstant: 322),
      header.topAnchor.constraint(equalTo: view.topAnchor),
      header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      header.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 322)
    
    viewModel.getProfiles() { [ weak self ] in
      if let profile = self?.viewModel.profile {
        header.configure(with: profile)
        self?.tableView.reloadData()
      }
    }
    
    tableView?.tableHeaderView = view
    tableView?.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.estimatedRowHeight = UITableView.automaticDimension
  }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.tweetDatas?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
      return UITableViewCell()
    }
    cell.configure(with: viewModel.tweetDatas?[indexPath.row] ?? Tweet())
    return cell
  }
}

