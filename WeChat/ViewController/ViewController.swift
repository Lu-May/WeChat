//
//  ViewController.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/25.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!

  private let refreshControl = UIRefreshControl()
  let viewModel = ViewModel()
  
  @objc private func refreshTableViewData(_ sender: Any) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
      self.viewModel.initDatas()
      self.viewModel.getTableViewDataSource()
      self.tableView.reloadData()
      self.refreshControl.endRefreshing()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "朋友圈"
        
    tableView.refreshControl = refreshControl
    
    refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
    
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
    return viewModel.tableViewDatas.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as? TableViewCell else {
      return UITableViewCell()
    }
    cell.configure(with: viewModel.tableViewDatas[indexPath.row] )
    return cell
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    let currentOffset = tableView.contentOffset.y
    let maximumOffset = tableView.contentSize.height - tableView.frame.size.height
    
    if maximumOffset - currentOffset <= 10.0 {
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
        print("reload")
        self.viewModel.getTableViewDataSource()
        self.tableView.reloadData()
      }
    }
  }
}

