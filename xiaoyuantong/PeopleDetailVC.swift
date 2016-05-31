//
//  PeopleDetailVC.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/30.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class PeopleDetailVC: MainVC,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    var intend:String
    var peopleID:String
    var friendInfo = NSArray()
    var peopleIcon:UIImage?
    var tableView:UITableView
    var topImageView:UIImageView!
    var editingTextField:UITextField!
    init(intend:String,peopleID:String,peopleIcon:UIImage?){
        self.intend = intend
        self.peopleID = peopleID
        self.tableView = UITableView()
        self.peopleIcon = peopleIcon
        super.init(nibName: nil, bg: UIColor.blackColor())
        self.view = self.tableView
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("I don't need to implement init(coder:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.frame.size.height -= 150
        self.tableView.frame.origin.y += 150
        topImageView = UIImageView(image: peopleIcon)
        topImageView.frame = CGRectMake(screen.width/2 - 75, 10, 150, 150)
        topImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0,0,screen.width,170))
        self.tableView.tableHeaderView!.addSubview(topImageView)
        print(self.tableView.tableHeaderView?.frame.height)
        
        
        
        
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
        return self.friendInfo.count != 0 ? 13 : 0
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
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if self.editingTextField != nil{
            self.editingTextField.resignFirstResponder()
            editingTextField = nil
        }
    }
    
    func getData(){
        dispatch_async(dispatch_get_global_queue(-2, 0), {
            let groupsData = Request.getRequestXYTFormat(Config.url+"profile", requestTimeOut: 8, tag: 10, datas: ("username",self.peopleID))
            do{
                let result = try NSJSONSerialization.JSONObjectWithData(groupsData!, options: NSJSONReadingOptions.AllowFragments)
                self.friendInfo = Friend(result: result).visibleValue()
                print(self.friendInfo)
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