//
//  HeaderView.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/28.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

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
        self.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(self.touch)))
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
