//
//  NotificationVC.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/6/1.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class NotificationVC:MainVC,UITableViewDelegate,UITableViewDataSource{
    var recvTableView:UITableView!
    var sendTableView:UITableView!
    var username:String
    var refreshControl:UIRefreshControl!
    let noticeList = NoticeList()
    
    
    init(username:String){
        self.username = username
        super.init(nibName: nil, bg: UIColor.whiteColor())
    }
    
    // MARK: - Refresh Data
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if !refreshControl.refreshing {
            refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据...")
        }
    }
    
    
    func refresh(){
        refreshControl.attributedTitle = NSAttributedString(string: "数据加载中...")
        self.getNotice()
    }
    
    func newNotice(){
        if let groupList = ContactVC.getGroupsList(){
            self.navigationController?.pushViewController(CreateNoticeVC(username: self.username,groupList: groupList), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知列表"
        let hbButton = UIButton(frame: CGRectMake(0,-15,30,30))
        hbButton.setTitle("\u{e60a}", forState: UIControlState.Normal)
        hbButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        hbButton.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
        hbButton.addTarget(self, action: #selector(self.newNotice), forControlEvents: UIControlEvents.TouchUpInside)
        hbButton.titleLabel!.font = UIFont(name: "iconfont", size: 20)
        let hbItem = UIBarButtonItem(customView: hbButton)
        self.navigationItem.rightBarButtonItem = hbItem
        recvTableView = UITableView()
        recvTableView.delegate = self
        recvTableView.dataSource = self
        recvTableView.registerClass(NoticeCell.self, forCellReuseIdentifier: "Cell")
        sendTableView = UITableView()
        sendTableView.delegate = self
        sendTableView.dataSource = self
        sendTableView.registerClass(NoticeCell.self, forCellReuseIdentifier: "Cell")
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), forControlEvents: UIControlEvents.ValueChanged)
        recvTableView.addSubview(refreshControl)
        self.view = recvTableView
        let tableViewChanger = UISegmentedControl(items: ["接收列表","发出列表"])
        tableViewChanger.addTarget(self, action: #selector(self.changeTableView(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.navigationItem.titleView = tableViewChanger
        tableViewChanger.selectedSegmentIndex = 0
        getNotice()
    }
    
    func changeTableView(sender:UISegmentedControl){
        refreshControl.removeFromSuperview()
        if sender.selectedSegmentIndex == 0{
            self.view = recvTableView
        }else{
            self.view = sendTableView
        }
        self.view.addSubview(refreshControl)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == recvTableView{
            return noticeList.recvList.count
        }else{
            return noticeList.sendList.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == recvTableView{
            let msg = noticeList.recvList[indexPath.row]
            let cell = recvTableView.dequeueReusableCellWithIdentifier("Cell") as! NoticeCell
            cell.setUp(msg)
            return cell
        }else{
            let msg = noticeList.sendList[indexPath.row]
            let cell = sendTableView.dequeueReusableCellWithIdentifier("Cell") as! NoticeCell
            cell.setUp(msg)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let msg = (tableView.cellForRowAtIndexPath(indexPath) as! NoticeCell).msg
        var vc:NoticeVC
        if tableView == recvTableView{
            vc = NoticeVC(isRecv: true,flag: (msg as! RecvNotice).flag, username: self.username, noticeID: msg.noticeID!)
        }else{
            vc = NoticeVC(isRecv: false,flag: false, username: self.username, noticeID: msg.noticeID! ,noticeGroup: (msg as! SendNotice).noticeGroup)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getNotice(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            self.getRecv()
            self.getSend()
            if self.refreshControl.refreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getRecv(){
        if let data = Request.getRequestXYTFormat(Config.url+"recmsgs", requestTimeOut: 5, tag: Config.GET_RECMSG_TAG, datas: ("username",self.username)){
            do{
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                noticeList.setRec(result)
                
            }catch{
                
            }
            dispatch_sync(dispatch_get_main_queue(), { 
                self.recvTableView.reloadData()
            })
            
        }
    }
    
    func getSend(){
        if let data = Request.getRequestXYTFormat(Config.url+"sendmsgs", requestTimeOut: 5, tag: Config.GET_RECMSG_TAG, datas: ("username",self.username)){
            do{
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                noticeList.setSend(result)
                
            }catch{
                
            }
            dispatch_sync(dispatch_get_main_queue(), {
                self.sendTableView.reloadData()
            })
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
