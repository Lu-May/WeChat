//
//  TweetsViewModelTest.swift
//  WeChatTests
//
//  Created by Yuehuan Lu on 2021/2/2.
//

import Quick
import Nimble
import UIKit
@testable import WeChat

class TweetViewModelTest: QuickSpec {
  let viewModel = TweetsViewModel()
  
  override func spec() {
    describe("initDatas") { [self] in
      context("when datas are empty") {
        it("shoulds be empty when it has been inited") {
          viewModel.initDatas()
          
          expect(viewModel.tweetDatas.count) == 0
          expect(viewModel.tableViewDatas.count) == 0
          expect(viewModel.originalDatas.count) == 0
        }
      }
      
      context("when datas have member") {
        it("shoulds be cleared") {
          viewModel.tableViewDatas = [Tweet(content: "???", sender: Sender(username: "Yan", nick: "Leah", avatar: "aaaa"), images: [Image(url: "aaa")], comments: [Comment(content: "none", sender: Sender(username: "Yan", nick: "Leah", avatar: "aaaa"))])]
          viewModel.tweetDatas = [Tweet(content: "???", sender: Sender(username: "Yan", nick: "Leah", avatar: "aaaa"), images: [Image(url: "aaa")], comments: [Comment(content: "none", sender: Sender(username: "Yan", nick: "Leah", avatar: "aaaa"))])]
          viewModel.originalDatas = [Tweet(content: "???", sender: Sender(username: "Lu", nick: "Leah", avatar: "aaaa"), images: [Image(url: "aaa")], comments: [Comment(content: "none", sender: Sender(username: "Lu", nick: "Leah", avatar: "aaaa"))])]
          
          viewModel.initDatas()
          
          expect(viewModel.tweetDatas.count) == 1
          expect(viewModel.tableViewDatas.count) == 0
          expect(viewModel.tweetDatas[0].sender?.username) == "Lu"
          expect(viewModel.originalDatas[0].sender?.username) == "Lu"
        }
      }
    }
    
    describe("getTableViewDataSource") {
      context("when the datas are empty") {
        it("shoulds return empty arrays") {
          self.viewModel.tweetDatas = []
          self.viewModel.tableViewDatas = []
          self.viewModel.originalDatas = []
          
          self.viewModel.getTableViewDataSource()
          
          expect(self.viewModel.tweetDatas.count) == 0
          expect(self.viewModel.tableViewDatas.count) == 0
          expect(self.viewModel.originalDatas.count) == 0
        }
      }
      
      context("when the datas have less than 5 members") {
        it("shoulds get the datas with there own rules") {
          self.addTweetDatas()
          self.addTweetDatas()

          expect(self.viewModel.tweetDatas.count) == 2
          expect(self.viewModel.tableViewDatas.count) == 0
          
          self.viewModel.getTableViewDataSource()
          expect(self.viewModel.tweetDatas.count) == 0
          expect(self.viewModel.tableViewDatas.count) == 2
        }
      }
      
      context("when the datas have more than 5 members") {
        it("shoulds get datas with there own rules") {
          self.viewModel.tweetDatas = []
          
          self.addTweetDatas()
          self.addTweetDatas()
          self.addTweetDatas()
          self.addTweetDatas()
          self.addTweetDatas()
          self.addTweetDatas()
          self.addTweetDatas()
          
          expect(self.viewModel.tweetDatas.count) == 7
          expect(self.viewModel.tableViewDatas.count) == 2
        }
      }
    }
  }
  
  func addTweetDatas() {
    self.viewModel.tweetDatas.append(contentsOf: [Tweet(content: "???", sender: Sender(username: "Yan", nick: "Leah", avatar: "aaaa"), images: [Image(url: "aaa")], comments: [Comment(content: "none", sender: Sender(username: "Yan", nick: "Leah", avatar: "aaaa"))])])
  }
}
