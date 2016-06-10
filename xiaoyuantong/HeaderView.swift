//
//  HeaderView.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/28.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class SelectHeaderView: HeaderView {
    var group:Group!
    var selectedButton:UIButton!
    var vc:CreateNoticeVC!
    var tableView:UITableView!

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        selectedButton = UIButton(frame: CGRectMake(screen.width-75,7,60,30))
        selectedButton.layer.cornerRadius = 8
        selectedButton.backgroundColor = Config.mainColor
        selectedButton.titleLabel?.font = UIFont.systemFontOfSize(14)
        selectedButton.addTarget(self, action: #selector(self.selected(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(selectedButton)
    }
    
    func selected(sender:UIButton){
        if let friends = group.friends{
            group.selected = !group.selected
            if group.selected{
                for friend in friends{
                    if vc.selectedUsername.indexOf(friend.username) == nil{
                        vc.selectedUsername.append(friend.username)
                    }
                    friend.selected = true
                }
            }else{
                for friend in friends{
                    if let index = vc.selectedUsername.indexOf(friend.username){
                        vc.selectedUsername.removeAtIndex(index)
                    }
                    friend.selected = false
                }
                
            }
            self.tableView.reloadData()
        }
        
    }
    
    func cancelSelected(){
        var selectedCount = 0
        if let friends = group.friends{
            for friend in friends{
                if friend.selected{
                    selectedCount += 1
                }
            }
            if selectedCount == friends.count{
                group.selected = true
                selectedButton.setTitle("取消全选", forState: UIControlState.Normal)
                return
            }
        }
        group.selected = false
        selectedButton.setTitle("全部选择", forState: UIControlState.Normal)
    }
    
    func setUp(groupName: String, section: Int, height: CGFloat, isClose: Bool, group:Group, vc:CreateNoticeVC, tableView:UITableView) {
        super.setUp(groupName, section: section, height: height, isClose: isClose)
        self.group = group
        self.vc = vc
        self.tableView = tableView
        if group.selected{
            selectedButton.setTitle("取消全选", forState: UIControlState.Normal)
        }else{
            selectedButton.setTitle("全部选择", forState: UIControlState.Normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class HeaderView: UITableViewHeaderFooterView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var statuView = UIView()
    var verticalLine = UIView()
    var horizontalLine = UIView()
    var isClose = true
    var section:Int!
    var groupNameLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        verticalLine.backgroundColor = UIColor.darkGrayColor()
        horizontalLine.backgroundColor = UIColor.darkGrayColor()
        statuView.addSubview(verticalLine)
        statuView.addSubview(horizontalLine)
        groupNameLabel.font = UIFont.systemFontOfSize(15)
        self.addSubview(groupNameLabel)
        self.addSubview(statuView)
    }
    
    func setUp(groupName:String,section:Int,height:CGFloat,isClose:Bool){
        self.section = section
        statuView.frame = CGRectMake(10,10,height-20,height-20)
        verticalLine.frame = CGRectMake(statuView.frame.size.width/2 - 1,(isClose ? 0 : self.statuView.frame.height/2),2,(isClose ? self.statuView.frame.height : 0))
        horizontalLine.frame = CGRectMake(0, statuView.frame.size.width/2 - 1, statuView.frame.height, 2)
        groupNameLabel.frame = CGRectMake(height,10,screen.width,height-20)
        groupNameLabel.text = groupName
    }
    
    
    func addGesture(gestureRecognizer: UIGestureRecognizer) {
        if let count = self.gestureRecognizers?.count{
            if count > 1{
                return
            }
        }
        self.addGestureRecognizer(gestureRecognizer)
    }
    
    func touch(toClose:Bool){
        UIView.animateWithDuration(0.1) {
            self.verticalLine.frame.origin.y = toClose ? 0 : self.statuView.frame.height/2
            self.verticalLine.frame.size.height = toClose ? self.statuView.frame.height : 0
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
