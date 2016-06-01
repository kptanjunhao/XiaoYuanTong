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
    init(intend:String,peopleID:String,peopleIcon:UIImage?){
        self.intend = intend
        self.peopleID = peopleID
        self.tableView = UITableView()
        self.peopleIcon = peopleIcon
        super.init(nibName: nil, bg: UIColor.blackColor())
        self.view = self.tableView
        let item = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.Done, target: self, action: #selector(self.submit))
        self.navigationItem.rightBarButtonItem = item
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

        topImageView = UIImageView(image: peopleIcon)
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
        var updateInfo = [String:AnyObject]()
        updateInfo["userrealname"] = friendInfo[1]
        updateInfo["usersignature"] = friendInfo[5]
        updateInfo["userphone"] = friendInfo[3]
        updateInfo["userqq"] = friendInfo[11]
        updateInfo["userweixin"] = friendInfo[12]
        print(updateInfo)
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
        self.topImageView.image = image
        picker.dismissViewControllerAnimated(true, completion: {
            self.topImageView.userInteractionEnabled = true
        })
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
            let groupsData = Request.getRequestXYTFormat(Config.url+"profile", requestTimeOut: 8, tag: 10, datas: ("username",self.peopleID))
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