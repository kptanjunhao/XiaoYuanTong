//
//  MainViewController.swift
//  SchoolBangBang
//
//  Created by 谭钧豪 on 16/5/16.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class ContactVC: MainVC,UITableViewDelegate,UITableViewDataSource {
    
    var tableView: UITableView!
    var refreshControl: UIRefreshControl!
    var username: String!
    var groupList:GroupList?
    var headerHeight:CGFloat = 40
    
    init(){

        super.init(nibName: nil, bg: UIColor(red: 0.9375, green: 0.9375, blue: 0.9375, alpha: 1))

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.getData), name: "loginSuccess", object: nil)
        self.title = "好友列表"
        self.tabBarItem.image = imageWithIcon("\u{e609}", fontName: "iconfont", size: 34, color: UIColor.blackColor())
        self.tabBarItem.selectedImage = imageWithIcon("\u{e608}", fontName: "iconfont", size: 34, color: UIColor.blackColor())
        self.tabBarItem.title = "通讯录"
        
        let toNotification = MenuButton(target: self, title: "通知", selector: #selector(self.notification))
        let toModifyInfo = MenuButton(target: self, title: "修改资料", selector: #selector(self.modify))
        let toMessageBoard = MenuButton(target: self, title: "留言板", selector: #selector(self.hi(_:)))
        let toLogout = MenuButton(target: self, title: "注销", selector: #selector(self.login))
        
        addMenuView(toNotification,toModifyInfo,toMessageBoard,toLogout)
        
        let hbButton = UIButton(frame: CGRectMake(0,0,30,30))
        hbButton.setTitle("\u{e605}", forState: UIControlState.Normal)
        hbButton.setTitle("\u{e604}", forState: UIControlState.Highlighted)
        hbButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        hbButton.addTarget(self, action: #selector(self.showMenu), forControlEvents: UIControlEvents.TouchUpInside)
        hbButton.titleLabel?.font = UIFont(name: "iconfont", size: 30)
        let hbItem = UIBarButtonItem(customView: hbButton)
        self.navigationItem.rightBarButtonItem = hbItem
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bg: UIColor.clearColor())
    }
    
    func notification(){
        self.navigationController?.pushViewController(NotificationVC(username:self.username), animated: true)
    }
    
    func modify(){
        self.navigationController?.pushViewController(PeopleDetailVC(intend: "modify",peopleID: self.username), animated: true)
    }
    
    func login(){
        NSUserDefaults.standardUserDefaults().setValue(false, forKey: "isLogin")
        dispatch_async(LOG_QUEUE) {
            Log.add("Translate", name: "进入登录界面", widget: "UIViewController")
        }
        let nav = LoginNC(background: UIColor(red:0.94, green:0.94, blue:0.94, alpha:1.00))
        self.tabBarController!.presentViewController(nav, animated: true, completion: nil)
    }
    
    static func getGroupsList() -> GroupList?{
        if let username = NSUserDefaults.standardUserDefaults().valueForKey("username"){
            let groupsData = Request.getRequestXYTFormat(Config.url+"groups", requestTimeOut: 3, tag: Config.GET_GROUPS_TAG, datas: ("username",username as! String))
            do{
                return GroupList(result: try NSJSONSerialization.JSONObjectWithData(groupsData!, options: NSJSONReadingOptions.AllowFragments))
                
            }catch{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func getData(){
        dispatch_async(dispatch_get_global_queue(-2, 0), {
            if let username = NSUserDefaults.standardUserDefaults().valueForKey("username"){
                self.username = username as! String
            }else{
                return
            }
            let groupsData = Request.getRequestXYTFormat(Config.url+"groups", requestTimeOut: 8, tag: Config.GET_GROUPS_TAG, datas: ("username",self.username))
            do{
                let result = try NSJSONSerialization.JSONObjectWithData(groupsData!, options: NSJSONReadingOptions.AllowFragments)
                self.groupList = GroupList(result: result)
                dispatch_sync(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
            }catch{
                let errmsg = "网络出错："+(error as NSError).localizedDescription
                let alert = UIAlertController(title: "", message: errmsg, preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1500000000), dispatch_get_main_queue(), {
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
            }
        })
    }
    
    func hi(sender:MenuButton){
        if let title = sender.currentTitle{
            switch title {
            case "通知":
                print("通知")
            default:
                print("找不到这个title")
            }
        }
//        do{
//            try self.menuView?.deleteItem(sender)
//        }catch{
//            print(error)
//        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.frame.size.height -= 112
        self.tableView.separatorStyle = .None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerNib(UINib(nibName: "FriendCell", bundle: nil), forCellReuseIdentifier: "FriendCell")
        self.tableView.registerClass(HeaderView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        self.view.addSubview(self.tableView)
    }
    
    // MARK: - Refresh Data
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if !refreshControl.refreshing {
            refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据...")
        }
    }
    
    
    func refresh(){
        refreshControl.attributedTitle = NSAttributedString(string: "数据加载中...")
        self.getData()
        refreshControl.endRefreshing()
    }
    
    //TableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let isClose = groupList?.groups[section].isClose{
            if isClose{
                return 0
            }else{
                return groupList?.groups[section].friends?.count ?? 0
            }
        }else{
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupList?.groups.count ?? 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func sectionTap(sender:UITapGestureRecognizer){
        let senderView = sender.view as! HeaderView
        let section = senderView.section
        self.tableView.beginUpdates()
        groupList!.groups[section].isClose = !groupList!.groups[section].isClose
        senderView.touch(groupList!.groups[section].isClose)
        let countOfRow = groupList!.groups[section].friends!.count
        var indexPaths = [NSIndexPath]()
        for i in 0..<countOfRow{
            indexPaths.append(NSIndexPath(forRow: i, inSection: section))
        }
        if groupList!.groups[section].isClose{
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        }else{
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        }
        self.tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("HeaderView") as! HeaderView
        let groupName = groupList!.groups[section].groupName + " \(groupList!.groups[section].friends!.count)位"
        headerView.setUp(groupName, section: section, height: headerHeight,isClose: groupList!.groups[section].isClose)
        headerView.addGesture(UITapGestureRecognizer(target: self, action: #selector(self.sectionTap(_:))))
        return headerView
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("FriendCell") as! FriendCell
        cell.setUp(groupList!.groups[indexPath.section].friends![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let friendID = groupList!.groups[indexPath.section].friends![indexPath.row].username
        let image = (self.tableView.cellForRowAtIndexPath(indexPath) as! FriendCell).icon.image
        self.navigationController?.pushViewController(PeopleDetailVC(intend: "lookUp",peopleID: friendID,peopleIcon: image), animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        func notLogin(){
            self.tabBarController!.selectedIndex = 0
        }
        if let isLogin = NSUserDefaults.standardUserDefaults().valueForKey("isLogin"){
            if !(isLogin as! Bool){
                groupList = nil
                self.tableView.reloadData()
                self.login()
            }else{
                self.getData()
            }
        }else{
            NSUserDefaults.standardUserDefaults().setValue(false, forKey: "isLogin")
            notLogin()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}