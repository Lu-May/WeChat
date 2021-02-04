//
//  ViewController.swift
//  WeChat
//
//  Created by Yuehuan Lu on 2021/1/25.
//

import UIKit

class TweetsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  private var tableHeaderView = TweetsHeader()
  private let refreshControl = UIRefreshControl()
  let viewModel = TweetsViewModel()
  let indicator = UIActivityIndicatorView()
  let tableFooterView = UITableViewHeaderFooterView()
  let footerLabel = UILabel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = "朋友圈"
    setIndicatorConstraint()
    
    setFooterLabel(tableFooterView: tableFooterView)
    tableView.refreshControl = refreshControl
    refreshControl.addTarget(self, action: #selector(refreshTableViewData(_:)), for: .valueChanged)
    
    viewModel.getTweetDatas() { [weak self] in
      self?.tableView.reloadData()
    }
    
    setUpTableViewHeader()
    
    viewModel.getProfiles() { [ weak self ] in
      if let profile = self?.viewModel.profile {
        self?.tableHeaderView.configure(with: profile)
      }
      self?.tableView.reloadData()
    }
    
    tableView.tableFooterView = tableFooterView
    tableView.register(UINib(nibName: "TweetCell", bundle: nil), forCellReuseIdentifier: "TweetCell")
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = UITableView.automaticDimension
  }
  
  @objc private func refreshTableViewData(_ sender: Any) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
      self.viewModel.initDatas()
      self.viewModel.getTableViewDataSource()
      self.tableView.reloadData()
      self.setIndicatorConstraint()
      self.refreshControl.endRefreshing()
      self.footerLabel.text = "上拉加载数据"
    }
  }
  
  private func setUpTableViewHeader() {
    let view = UIView()
    tableHeaderView = Bundle.main.loadNibNamed("TweetsHeader", owner: nil, options: nil)?.first as! TweetsHeader
    view.addSubview(tableHeaderView)
    view.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 322)
    tableHeaderView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      tableHeaderView.topAnchor.constraint(equalTo: view.topAnchor),
      tableHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableHeaderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    tableView.tableHeaderView = view
  }
  
  private func setIndicatorConstraint() {
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
  
  private func setFooterLabel(tableFooterView: UITableViewHeaderFooterView) {
    tableFooterView.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 50)
    footerLabel.font = footerLabel.font.withSize(12)
    footerLabel.textColor = UIColor.lightGray
    footerLabel.text = "上拉加载数据"
    footerLabel.textAlignment = .center
    self.tableFooterView.addSubview(footerLabel)
    footerLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      footerLabel.topAnchor.constraint(equalTo: self.tableFooterView.topAnchor),
      footerLabel.trailingAnchor.constraint(equalTo: self.tableFooterView.trailingAnchor),
      footerLabel.leadingAnchor.constraint(equalTo: self.tableFooterView.leadingAnchor),
      footerLabel.bottomAnchor.constraint(equalTo: self.tableFooterView.bottomAnchor)
    ])
  }
}

extension TweetsViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.tableViewDatas.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as? TweetCell else {
      return UITableViewCell()
    }
    cell.configure(with: viewModel.tableViewDatas[indexPath.row])
    return cell
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let currentOffset = tableView.contentOffset.y
    let maximumOffset = tableView.contentSize.height - tableView.frame.size.height
    
    if maximumOffset - currentOffset <= 10.0 {
      self.indicator.startAnimating()
      
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
        self.indicator.hidesWhenStopped = true
        if self.viewModel.tweetDatas.count == 0 {
          self.footerLabel.text = "数据加载完毕"
          self.indicator.removeFromSuperview()
        }
        self.viewModel.getTableViewDataSource()
        self.tableView.reloadData()
        self.indicator.stopAnimating()
      }
    }
  }
}

