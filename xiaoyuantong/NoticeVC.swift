//
//  CreateNoticeVC.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/6/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class NoticeVC: MainVC{
    var username:String
    var selectedLabel:UILabel!
    var contentView:UITextView!
    var titleTextView:UITextView!
    var isRecv:Bool
    var noticeGroup:String?
    var notice = Notice(title: "", noticeID: "")
    var timeTextView:UITextView!
    var flag:Bool
    
    /**
     - parameters:
        - isRecv: Bool true代表收件箱的信息
        - noticeGroup:String    如果是发件箱的信息，则必须传noticeGroup:String过来
        - flag: Bool 如果是收件箱，则传通知的flag，如果是发件箱，则传false
     */
    init(isRecv:Bool,flag:Bool,username:String,noticeID:String,noticeGroup:String...){
        self.username = username
        self.isRecv = isRecv
        self.flag = flag
        self.notice.noticeID = noticeID
        if noticeGroup.count > 0{
            self.noticeGroup = noticeGroup[0]
        }
        super.init(nibName: nil, bg: UIColor.whiteColor())
    }
    
    
    var titleViewLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleView = UIView(frame: CGRectMake(0,0,screen.width/2,44))
        titleViewLabel = UILabel(frame: CGRectMake(0,0,screen.width/2,44))
        titleViewLabel.textAlignment = .Center
        titleViewLabel.textColor = UIColor.whiteColor()
        titleView.addSubview(titleViewLabel)
        self.navigationItem.titleView = titleView
        self.title = "通知详情"
        let titleLine = UIView(frame: CGRectMake(0,44,screen.width,1))
        titleLine.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(titleLine)
        
        let peopleLine = UIView(frame: CGRectMake(0,88,screen.width,1))
        peopleLine.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(peopleLine)
        let titleLabel = UILabel(frame: CGRectMake(15,7,70,30))
        titleLabel.text = " 标  题 :"
        titleLabel.textColor = UIColor.lightGrayColor()
        titleTextView = UITextView(frame: CGRectMake(88,3,screen.width-103,30))
        titleTextView.font = titleLabel.font
        titleTextView.editable = false
        titleTextView.scrollEnabled = false
        selectedLabel = UILabel(frame: CGRectMake(88,51,screen.width-138,30))
        selectedLabel.font = UIFont.systemFontOfSize(14)
        self.view.addSubview(selectedLabel)
        let peopleLabel = UILabel(frame: CGRectMake(15,51,70,30))
        peopleLabel.userInteractionEnabled = true
        peopleLabel.text = " 时  间 :"
        peopleLabel.textColor = UIColor.lightGrayColor()
        timeTextView = UITextView(frame: CGRectMake(88,47,screen.width-103,30))
        timeTextView.font = titleLabel.font
        timeTextView.editable = false
        timeTextView.scrollEnabled = false
        self.view.addSubview(titleLabel)
        self.view.addSubview(peopleLabel)
        self.view.addSubview(timeTextView)
        self.view.addSubview(titleTextView)
        
        contentView = UITextView()
        contentView.font = UIFont.systemFontOfSize(16)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(contentView)
        NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 15).active = true
        NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -15).active = true
        NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: peopleLine, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 7).active = true
        NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -7).active = true
        
        
        
        getNoticeDetail()
        
    }
    
    func refresh(){
        self.titleTextView.text = self.notice.title
        self.timeTextView.text = self.notice.time
        if self.isRecv{
            let recvNotice = self.notice as! RecvNotice
            self.contentView.text = recvNotice.noticeText
        }else{
            let sendNotice = self.notice as! SendNotice
            self.contentView.text = sendNotice.noticeText
        }
    }
    
    func getNoticeDetail(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            let action = self.isRecv ? "recmsg" : "sendmsg"
            if let data = Request.getRequestXYTFormat(Config.url+action, requestTimeOut: 5, tag: Config.GET_NOTICEDETAIL_TAG, datas: ("noticeid",self.notice.noticeID!),("noticegroup",self.noticeGroup ?? "")){
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
                    let title = json.objectForKey("noticetitle") as? String ?? "获取标题失败"
                    let content = json.objectForKey("noticetext") as? String ?? "获取内容失败"
                    let flag = json.objectForKey("noticereceiveflag")?.boolValue ?? false
                    let time = json.objectForKey("datetime") as? String ?? "00"
                    if self.isRecv{
                        let fromUsername = json.objectForKey("noticefrom") as? String ?? "0"
                        let fromName = json.objectForKey("realname") as? String ?? "获取发件人失败"
                        self.notice = RecvNotice(noticeID: self.notice.noticeID!, title: title, noticeText: content, flag: flag, time: time, noticeFromName: fromName, noticeFromUsername: fromUsername)
                    }else{
                        let replyCount = json.objectForKey("replyCount")?.integerValue ?? 0
                        let unReplyCount = json.objectForKey("unReplyCount")?.integerValue ?? 0
                        self.notice = SendNotice(title: title, noticeID: self.notice.noticeID!, time: time, noticeGroup: self.noticeGroup!, noticeText: content, replyCount: replyCount, unReplyCount: unReplyCount)
                    }
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.refresh()
                    })
                    
                }catch{
                    
                }
            }
            
        }
    }

    var isInitAppear = true
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if isInitAppear{
            let deleteButton = UIButton(frame: CGRectMake(15,self.view.frame.height - 45,screen.width - 30,30))
            deleteButton.setTitle("删  除", forState: UIControlState.Normal)
            deleteButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            deleteButton.backgroundColor = UIColor.redColor()
            deleteButton.layer.cornerRadius = 8
            deleteButton.addTarget(self, action: #selector(self.submit(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(deleteButton)
            if isRecv && flag{
                let confirmButton = UIButton(frame: CGRectMake(screen.width/2 + 7.5,self.view.frame.height - 45,screen.width/2 - 22.5,30))
                confirmButton.setTitle("确  定", forState: UIControlState.Normal)
                confirmButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                confirmButton.backgroundColor = Config.mainColor
                confirmButton.layer.cornerRadius = 8
                confirmButton.tag = 9
                confirmButton.addTarget(self, action: #selector(self.submit(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                deleteButton.frame = CGRectMake(15,self.view.frame.height - 45,screen.width/2 - 22.5,30)
                self.view.addSubview(confirmButton)
            }
        }
    }
    
    func submit(sender:UIButton){
        
        let tip = UIAlertController(title: "提示", message: "正在请求", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(tip, animated: true, completion: nil)
        var isDelete = false
        if sender.tag != 9{
            isDelete = true
        }
        let message = isDelete ? "删除" : "确认通知"
        let action = isDelete ? "deletenotice" : "noticeconfirm"
        
        if let data = Request.getRequestXYTFormat(Config.url+action, requestTimeOut: 3, tag: 0, datas: ("noticeid",self.notice.noticeID!),("username",self.username),("fromorto","2")){
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as? Int
                var statu = false
                var alert:UIAlertController
                let ok = UIAlertAction(title: "好", style: .Default, handler: {
                    (_) -> Void in
                    if statu{
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
                if json == 0{
                    statu = true
                    alert = UIAlertController(title: "提示", message: "成功"+message, preferredStyle: .Alert)
                }else{
                    alert = UIAlertController(title: "提示", message: message+"失败", preferredStyle: .Alert)
                }
                alert.addAction(ok)
                tip.dismissViewControllerAnimated(true, completion: {
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }catch{
                print(error)
            }
        }else{
            let alert = UIAlertController(title: "提示", message: "与服务器连接发生错误", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "好", style: .Default, handler: {
                (OK) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            })
            alert.addAction(ok)
            tip.dismissViewControllerAnimated(true, completion: {
                self.presentViewController(alert, animated: true, completion: nil)
            })
        }

    }
    
    func deleteNotice(){
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class CreateNoticeVC:MainVC,UITextViewDelegate{
    
    var username:String
    var groupList:GroupList
    var selectedUsername = [String]()
    var selectedLabel:UILabel!
    var someLabel:UILabel!
    var contentView:UITextView!
    var titleTextField:UITextField!
    
    init(username:String,groupList:GroupList){
        self.username = username
        self.groupList = groupList
        super.init(nibName: nil, bg: UIColor.whiteColor())
        let submitItem = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.submit))
        self.navigationItem.rightBarButtonItem = submitItem
    }
    
    func submit(){
        self.exitEditing()
        let paras:NSMutableDictionary = [
            "person" : selectedUsername,
            "ishasperson" : true,
            "unregister" : "0",
            "status" : "all",
            "username" : username,
            "publish" : [
                "title" : titleTextField.text!,
                "content" : contentView.text
            ]
        ]
        var parasdata:NSData!
        do{
            parasdata = try NSJSONSerialization.dataWithJSONObject(paras, options: NSJSONWritingOptions.PrettyPrinted)
        }catch{
            print(error)
        }
        var parasstr = NSString(data: parasdata, encoding: NSUTF8StringEncoding) as! String

        parasstr = parasstr.stringByReplacingOccurrencesOfString("{\n    ", withString: "{")
        parasstr = parasstr.stringByReplacingOccurrencesOfString("{\n  ", withString: "{")
        parasstr = parasstr.stringByReplacingOccurrencesOfString("\n  }", withString: "}")
        parasstr = parasstr.stringByReplacingOccurrencesOfString("\n}", withString: "}")
        parasstr = parasstr.stringByReplacingOccurrencesOfString(",\n    ", withString: ",")
        parasstr = parasstr.stringByReplacingOccurrencesOfString(",\n  ", withString: ",")
        parasstr = parasstr.stringByReplacingOccurrencesOfString("\" : ", withString: "\":")
        parasstr = parasstr.stringByReplacingOccurrencesOfString("[\n    ", withString: "[")
        parasstr = parasstr.stringByReplacingOccurrencesOfString("[\n  ", withString: "[")
        parasstr = parasstr.stringByReplacingOccurrencesOfString("\n  ]", withString: "]")

        parasdata = (parasstr+"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!
        let attrData = Request.appendedData((parasdata,"data"))
        let attrstr = NSString(data: attrData, encoding: NSUTF8StringEncoding) as! String
        print(attrstr)
        Request.postRequest(attrData, url: NSURL(string: Config.url+"publish")!, requestTimeOut: 3, tag: Config.SEND_NOTICE_TAG)
        let alert = UIAlertController(title: "提示", message: "已发送", preferredStyle: UIAlertControllerStyle.Alert)
        self.presentViewController(alert, animated: true) { 
            alert.dismissViewControllerAnimated(true, completion: { 
                self.navigationController?.popViewControllerAnimated(true)
            })
        }
    }
    
    var titleViewLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleView = UIView(frame: CGRectMake(0,0,screen.width/2,44))
        titleViewLabel = UILabel(frame: CGRectMake(0,0,screen.width/2,44))
        titleViewLabel.textAlignment = .Center
        titleViewLabel.textColor = UIColor.whiteColor()
        titleViewLabel.text = "点此处可收起键盘"
        titleView.addSubview(titleViewLabel)
        self.navigationItem.titleView = titleView
        self.navigationItem.titleView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.exitEditing)))
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.textFieldDidChange(_:)), name: UITextFieldTextDidChangeNotification, object: nil)
        self.title = "通知"
        let titleLine = UIView(frame: CGRectMake(0,44,screen.width,1))
        titleLine.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(titleLine)
        
        let peopleLine = UIView(frame: CGRectMake(0,88,screen.width,1))
        peopleLine.backgroundColor = UIColor.lightGrayColor()
        self.view.addSubview(peopleLine)
        let titleLabel = UILabel(frame: CGRectMake(15,7,70,30))
        titleLabel.text = " 标  题 :"
        titleLabel.textColor = UIColor.lightGrayColor()
        titleTextField = UITextField(frame: CGRectMake(88,7,screen.width-103,30))
        titleTextField.font = titleLabel.font
        titleTextField.placeholder = "请输入不超过20字的标题"
        selectedLabel = UILabel(frame: CGRectMake(88,51,screen.width-138,30))
        selectedLabel.font = UIFont.systemFontOfSize(14)
        self.view.addSubview(selectedLabel)
        someLabel = UILabel(frame: CGRectMake(screen.width-50,51,40,30))
        someLabel.font = UIFont.systemFontOfSize(13)
        self.view.addSubview(someLabel)
        let peopleLabel = UILabel(frame: CGRectMake(15,51,screen.width-30,30))
        peopleLabel.userInteractionEnabled = true
        peopleLabel.text = "收件人:"
        peopleLabel.textColor = UIColor.lightGrayColor()
        peopleLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectPeople)))
        self.view.addSubview(titleLabel)
        self.view.addSubview(peopleLabel)
        self.view.addSubview(titleTextField)
        
        contentView = UITextView()
        contentView.font = UIFont.systemFontOfSize(16)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.delegate = self
        self.view.addSubview(contentView)
        NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 15).active = true
        NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: -15).active = true
        NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: peopleLine, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 7).active = true
        NSLayoutConstraint(item: contentView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -7).active = true
        
    }
    
    func exitEditing(){
        titleTextField.resignFirstResponder()
        contentView.resignFirstResponder()
    }
    
    func textFieldDidChange(sender:NSNotification){
        if let textField = sender.object as? UITextField{
            let toBeString = textField.text
            if let lang = textField.textInputMode?.primaryLanguage{
                if lang.containsString("zh-Hans"){// 简体中文输入，包括简体拼音，健体五笔，简体手写
                    if textField.markedTextRange == nil{//判断高亮部分
                        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
                        if toBeString?.characters.count > 20{
                            textField.text = toBeString!.substringToIndex(toBeString!.startIndex.advancedBy(20))
                        }
                    }//有高亮选择的字符串，则暂不对文字进行统计和限制
                }
            }else{// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
                if toBeString?.characters.count > 20{
                    textField.text = toBeString!.substringToIndex(toBeString!.startIndex.advancedBy(20))
                }
            }
        }
    }
    
    
    func selectPeople(){
        let selectPeopleVC = SelectPeopleVC(groupList: self.groupList,vc: self)
        self.navigationController!.pushViewController(selectPeopleVC, animated: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.exitEditing()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let realnames = groupList.getRealnameByUsername(selectedUsername)
        var str = ""
        for realname in realnames{
            str += (realname + ",")
        }
        self.selectedLabel.text = str
        self.someLabel.text = selectedUsername.count == 0 ? "" : "共\(selectedUsername.count)人"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(5) {
            self.titleViewLabel.textColor = UIColor.clearColor()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
