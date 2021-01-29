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
  let indicator = UIActivityIndicatorView()
  let tableFooterView = UITableViewHeaderFooterView()
  let lable = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "朋友圈"
    setIndicatorConstraint()
    tableFooterView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)

    setFooterLable()
    
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
    
    viewModel.getTweetDatas() { [weak self] in
      self?.tableView.reloadData()
    }

    let view = UIView()
    let header = Bundle.main.loadNibNamed("TableViewHeader", owner: nil, options: nil)?.first as! TableViewHeader
    view.addSubview(header)
    
    setTableViewHeaderConstraint(header, view)
    
    view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 322)
    
    viewModel.getProfiles() { [ weak self ] in
      if let profile = self?.viewModel.profile {
        header.configure(with: profile)
        self?.tableView.reloadData()
      }
    }
    
    tableView?.tableFooterView = tableFooterView
    tableView?.tableHeaderView = view
    tableView?.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "TableViewCell")
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.estimatedRowHeight = UITableView.automaticDimension
  }
  
  @objc private func refreshTableViewData(_ sender: Any) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
      self.viewModel.initDatas()
      self.viewModel.getTableViewDataSource()
      self.tableView.reloadData()
      self.lable.text = "上拉加载数据"
      self.setIndicatorConstraint()

      self.refreshControl.endRefreshing()
    }
  }
  
  fileprivate func setTableViewHeaderConstraint(_ header: TableViewHeader, _ view: UIView) {
    header.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      header.topAnchor.constraint(equalTo: view.topAnchor),
      header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      header.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  fileprivate func setIndicatorConstraint() {
    tableFooterView.addSubview(indicator)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      indicator.topAnchor.constraint(equalTo: tableFooterView.topAnchor),
      indicator.trailingAnchor.constraint(equalTo: tableFooterView.trailingAnchor),
      indicator.leadingAnchor.constraint(equalTo: tableFooterView.leadingAnchor),
      indicator.bottomAnchor.constraint(equalTo: tableFooterView.bottomAnchor)
    ])
    indicator.center = tableFooterView.center
  }
  
  fileprivate func setFooterLable() {
    lable.font = lable.font.withSize(12)
    lable.textColor = UIColor.lightGray
    lable.text = "上拉加载数据"
    lable.textAlignment = .center
    self.tableFooterView.addSubview(lable)
    lable.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      lable.topAnchor.constraint(equalTo: self.tableFooterView.topAnchor),
      lable.trailingAnchor.constraint(equalTo: self.tableFooterView.trailingAnchor),
      lable.leadingAnchor.constraint(equalTo: self.tableFooterView.leadingAnchor),
      lable.bottomAnchor.constraint(equalTo: self.tableFooterView.bottomAnchor)
    ])
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
      self.indicator.startAnimating()

      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
        self.indicator.hidesWhenStopped = true
        if self.viewModel.tweetDatas?.count == 0 {
          self.lable.text = "数据加载完毕"
          self.indicator.removeFromSuperview()
        }
        self.viewModel.getTableViewDataSource()
        self.tableView.reloadData()
        self.indicator.stopAnimating()
      }
    }
  }
}

