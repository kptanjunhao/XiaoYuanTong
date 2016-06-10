//
//  PeopleDetailVC.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/30.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit


class PeopleDetailVC: MainVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    var intend:String
    var peopleID:String
    var friendInfo = NSMutableArray()
    var peopleIcon:UIImage?
    var tableView:UITableView
    var topImageView:UIImageView!
    var editingTextField:UITextField!
    var tableViewHeight:CGFloat!
    var restoreIconButton:UIButton!
    
    //let imageURL = NSURL(string: Config.url + "faces/" + self.username + ".jpg")
    
    init(intend:String,peopleID:String){
        self.intend = intend
        self.peopleID = peopleID
        self.tableView = UITableView()
        self.tableView.separatorStyle = .None
        super.init(nibName: nil, bg: UIColor.blackColor())
        self.view = self.tableView
        if intend == "modify"{
            self.title = "修改资料"
            let item = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.submit))
            self.navigationItem.rightBarButtonItem = item
        }
    }
    
    convenience init(intend:String,peopleID:String,peopleIcon:UIImage?){
        self.init(intend:intend,peopleID:peopleID)
        self.peopleIcon = peopleIcon
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("I don't need to implement init(coder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        getData()
        self.tableView.delegate = self
        self.tableView.dataSource = self

        topImageView = UIImageView()
        topImageView.setZYHWebImage(Config.url + "faces/" + self.peopleID + ".jpg", defaultImage: "loading", isCache: false)
        topImageView.frame = CGRectMake(screen.width/2 - 75, 10, 150, 150)
        topImageView.contentMode = UIViewContentMode.ScaleAspectFill
        topImageView.userInteractionEnabled = true
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0,0,screen.width,170))
        self.tableView.tableHeaderView!.addSubview(topImageView)
        if intend == "modify"{
            self.topImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.selectImage(_:))))
        }
        
    }
    
    func submit(){
        if self.editingTextField != nil{
            if self.editingTextField.tag != 0{
                self.textFieldEndEditing(self.editingTextField.tag)
            }
            self.editingTextField.resignFirstResponder()
            self.editingTextField = nil
        }
        let infoSemaphore = dispatch_semaphore_create(Config.UPDATE_INFO_TAG)
        let iconSemaphore = dispatch_semaphore_create(Config.UPLOADICON_TAG)
        var infoStatu:Bool?
        var iconStatu:Bool?
        var alert = UIAlertController(title: nil, message: "正在更新资料", preferredStyle: UIAlertControllerStyle.Alert)
        var alertIsShowed = Bool()
        var cancelAction:UIAlertAction!{
            didSet{
                if cancelAction == nil{
                    cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (_) in
                        let updateInfoTask = Request.tasks[Config.UPDATE_INFO_TAG]
                        let updateIconTask = Request.tasks[Config.UPLOADICON_TAG]
                        updateIconTask?.cancel()
                        updateInfoTask?.cancel()
                    })
                }
            }
        }
        cancelAction = nil
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: {
            alertIsShowed = true
        })
        func dismissAlertWithMSG(msg:String,waitingAction:Bool){
            dispatch_async(dispatch_get_main_queue()) {
                alert.dismissViewControllerAnimated(true, completion: { 
                    alert = UIAlertController(title: nil, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
                    if waitingAction{
                        cancelAction = nil
                        alert.addAction(cancelAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    }else{
                        cancelAction = UIAlertAction(title: "好", style: UIAlertActionStyle.Default, handler: nil)
                        alert.addAction(cancelAction)
                        self.presentViewController(alert, animated: true, completion: { 
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1500000000), dispatch_get_main_queue(), {
                                alert.dismissViewControllerAnimated(true, completion: nil)
                            })
                        })
                    }
                    
                    
                })
            }
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = Request.getRequestXYTFormat(Config.url+"updateinfo",
                                        requestTimeOut: 5,
                                        tag: Config.UPDATE_INFO_TAG,
                                        datas:
                                        ("username",self.peopleID),
                                        ("realname",self.friendInfo[1] as! String),
                                        ("signature",self.friendInfo[5] as! String),
                                        ("phone",self.friendInfo[3] as! String),
                                        ("qq",self.friendInfo[11] as! String),
                                        ("weixin",self.friendInfo[12] as! String)
            )
            if let resultStr = NSString(data: data!, encoding: NSUTF8StringEncoding){
                var msg = "更新资料"
                if !resultStr.containsString("0"){
                    infoStatu = false
                    msg += "失败"
                }else{
                    infoStatu = true
                    msg += "成功"
                }
                if let iconStatu = iconStatu{
                    msg = iconStatu ? msg : msg+"，上传头像失败"
                    dismissAlertWithMSG(msg,waitingAction: false)
                }else{
                    msg += "正在上传头像"
                    dismissAlertWithMSG(msg,waitingAction: true)
                }
            }else{
                dismissAlertWithMSG("网络出错",waitingAction: false)
            }
            dispatch_semaphore_signal(infoSemaphore)
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            if self.restoreIconButton != nil{
                //上传头像
                let iconData = UIImageJPEGRepresentation(self.topImageView.image!, 1)!
                let httpbody = Request.appendedData((iconData,"jpg\"; filename=\"\(self.peopleID).jpg"),(self.peopleID.dataUsingEncoding(NSUTF8StringEncoding)!,"username"))
                let data = Request.postRequest(httpbody, url: NSURL(string: Config.url+"uploadface")!, requestTimeOut: 30, tag: Config.UPLOADICON_TAG)
                if let resultStr = NSString(data: data!, encoding: NSUTF8StringEncoding){
                    var msg = "上传头像"
                    if !resultStr.containsString("1"){
                        iconStatu = false
                        msg += "失败"
                    }else{
                        iconStatu = true
                        msg += "成功"
                    }
                    if let infoStatu = infoStatu{
                        msg = infoStatu ? "更新资料成功" : msg+"，更新资料失败"
                        dismissAlertWithMSG(msg,waitingAction: false)
                    }else{
                        msg += "正在上传资料"
                        dismissAlertWithMSG(msg,waitingAction: true)
                    }
                }else{
                    dismissAlertWithMSG("网络出错",waitingAction: false)
                }
            }else{
                iconStatu = true
            }
            dispatch_semaphore_signal(iconSemaphore)
        }
        dispatch_semaphore_wait(infoSemaphore, 5)
        dispatch_semaphore_wait(iconSemaphore, 30)
        
        
        
       
    }
    
    func keyboardWillChangeFrame(sender:NSNotification){
        let duration = sender.userInfo![UIKeyboardAnimationDurationUserInfoKey] as? NSTimeInterval ?? 0
        let keyboardHeight = (sender.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue() ?? CGRectZero).size.height
        let keyboardY = (sender.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue() ?? CGRectZero).origin.y
        if screen.height != keyboardY{
            dispatch_async(dispatch_get_main_queue(), {
                var row: Int?
                if self.editingTextField != nil{
                    var next: UIView? = self.editingTextField
                    while next != nil {
                        let nextResponder = next!.nextResponder()
                        if nextResponder!.isKindOfClass(UserDetailCell.classForCoder()){
                            row = (nextResponder as! UserDetailCell).row
                            break
                        }
                        next = next!.superview
                    }
                }
                
                UIView.animateWithDuration(duration, animations: {
                    self.tableView.frame.size.height = self.tableViewHeight + 49 - keyboardHeight
                    },completion:{
                        (_) in
                        if row != nil{
                            let indexPath = NSIndexPath(forRow: row!, inSection: 0)
                            self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
                        }
                })
            })
            
        }else if self.tableView.frame.size.height != self.tableViewHeight{
            dispatch_async(dispatch_get_main_queue(), { 
                UIView.animateWithDuration(duration, animations: {
                    self.tableView.frame.size.height = self.tableViewHeight
                })
            })
            
        }
    }
    
    
    
    func selectImage(sender:UIImageView){
        if peopleIcon == nil{
            let loadingdata = UIImageJPEGRepresentation(UIImage(named: "loading")!, 0.01)
            let imagedata = UIImageJPEGRepresentation(self.topImageView.image!, 0.01)
            if imagedata == loadingdata{
                let alert = UIAlertController(title: nil, message: "头像正在加载中，请稍侯", preferredStyle: UIAlertControllerStyle.Alert)
                self.presentViewController(alert, animated: true, completion: { 
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1000000000), dispatch_get_main_queue(), { 
                        alert.dismissViewControllerAnimated(true, completion: nil)
                    })
                })
                return
            }else{
                self.peopleIcon = self.topImageView.image!
            }
        }
        if self.editingTextField != nil{
            self.editingTextField.resignFirstResponder()
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        if restoreIconButton == nil{
            restoreIconButton = UIButton(type: UIButtonType.System)
            restoreIconButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
            restoreIconButton.layer.cornerRadius = 8
            restoreIconButton.frame = CGRectMake(screen.width/2 - 30, self.topImageView.frame.height-12, 60, 20)
            restoreIconButton.setTitle("还原", forState: UIControlState.Normal)
            restoreIconButton.addTarget(self, action: #selector(self.restoreIcon), forControlEvents: UIControlEvents.TouchUpInside)
            self.tableView.tableHeaderView!.addSubview(restoreIconButton)
        }
        self.topImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: {
            self.topImageView.userInteractionEnabled = true
        })
    }
    
    func restoreIcon(){
        topImageView.image = peopleIcon
        restoreIconButton.removeFromSuperview()
        restoreIconButton = nil
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        let offsetH = 0 - offsetY
        
        if (offsetH < 0) {
            return
        }
        
        var frame = self.topImageView.frame
        frame.size.height = 150 + offsetH
        frame.origin.y = 10 - offsetH
        self.topImageView.frame = frame

    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.friendInfo.count != 0 ? 7 : 0
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if intend == "modify"{
            return 40
        }
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if intend == "modify"{
            return UserDetailCell(row: indexPath.row, friendInfo: friendInfo,vc: self)
        }else{
            return PeopleDetailCell(row: indexPath.row, friendInfo: friendInfo)
        }
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.editingTextField = textField
    }
    
    func textFieldEndEditing(tag:Int){
        print(friendInfo)
        friendInfo[tag] = self.editingTextField.text!
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.tableViewHeight == nil{
            self.tableViewHeight = self.tableView.frame.size.height
        }
    }
    
    func getData(){
        dispatch_async(dispatch_get_global_queue(-2, 0), {
            let groupsData = Request.getRequestXYTFormat(Config.url+"profile", requestTimeOut: 8, tag: Config.GET_USERINFO_TAG, datas: ("username",self.peopleID))
            do{
                let result = try NSJSONSerialization.JSONObjectWithData(groupsData!, options: NSJSONReadingOptions.AllowFragments)
                self.friendInfo = Friend(result: result).visibleValue()
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
}