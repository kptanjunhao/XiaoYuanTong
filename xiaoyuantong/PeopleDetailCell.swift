//
//  PeopleDetailCell.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/30.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class FunctionalButton:UIButton{
    init(frame:CGRect,fontName:String,fontSize:CGFloat,normalTitle:String,highlightedTitle:String,
         titleColor:UIColor,target:AnyObject,action:Selector){
        super.init(frame: frame)
        self.titleLabel!.font = UIFont(name: fontName,size: fontSize)
        self.setTitle(normalTitle, forState: .Normal)
        self.setTitleColor(titleColor, forState: UIControlState.Normal)
        self.setTitle(highlightedTitle, forState: UIControlState.Highlighted)
        self.addTarget(target, action: action, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("I don't need to implement init(coder:)")
    }
}

class PeopleDetailCell: UITableViewCell {
    
    var row:Int = 0
    var nameLabel:UILabel!
    var infoLabel:UILabel!
    
    
    init(row:Int,friendInfo:NSArray){
        self.row = row
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        switch row {
        case 0:
            nameLabel = UILabel(frame: CGRectMake(screen.width/2-100,0,200,30))
            nameLabel.textAlignment = .Center
            nameLabel.font = UIFont.boldSystemFontOfSize(20)
            nameLabel.text = friendInfo[1] as? String
            infoLabel = UILabel(frame: CGRectMake(0,30,screen.width,20))
            infoLabel.textAlignment = .Center
            infoLabel.font = UIFont.systemFontOfSize(14)
            infoLabel.text = "\(friendInfo[8])  \(friendInfo[6])  \(friendInfo[7])"
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
        case 1:
            nameLabel = UILabel(frame: CGRectMake(15,10,200,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.text = "个性签名"
            nameLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UILabel(frame: CGRectMake(15,30,screen.width,20))
            infoLabel.font = UIFont.italicSystemFontOfSize(17)
            infoLabel.text = "\(friendInfo[5])"
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
        case 2:
            nameLabel = UILabel(frame: CGRectMake(15,10,200,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.text = "电话"
            nameLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UILabel(frame: CGRectMake(15,30,screen.width,20))
            infoLabel.font = UIFont.systemFontOfSize(14)
            infoLabel.text = "\(friendInfo[3])"
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
            
            let msgBtn = FunctionalButton(frame: CGRectMake(screen.width-90,10,30,30), fontName: "iconfont", fontSize: 30, normalTitle: "\u{e603}", highlightedTitle: "\u{e601}", titleColor: Config.mainColor, target: self, action: #selector(self.msg))
            self.addSubview(msgBtn)
            let phoneBtn = FunctionalButton(frame: CGRectMake(screen.width-45,10,30,30), fontName: "iconfont", fontSize: 30, normalTitle: "\u{e602}", highlightedTitle: "\u{e600}", titleColor: Config.mainColor, target: self, action: #selector(self.call))
            self.addSubview(phoneBtn)
        case 3:
            nameLabel = UILabel(frame: CGRectMake(15,10,100,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.text = "账号信息"
            nameLabel.textColor = UIColor.lightGrayColor()
            let registerLabel = UILabel(frame: CGRectMake(100,30,50,20))
            registerLabel.font = UIFont.systemFontOfSize(12)
            registerLabel.text = ((friendInfo[10] as! Bool) ? "(已注册)" : "(未注册)")
            registerLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UILabel(frame: CGRectMake(15,30,screen.width,20))
            infoLabel.font = UIFont.systemFontOfSize(14)
            infoLabel.text = "\(friendInfo[2])"
            self.addSubview(nameLabel)
            self.addSubview(registerLabel)
            self.addSubview(infoLabel)
        case 4,5,6:
            nameLabel = UILabel(frame: CGRectMake(15,10,200,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UILabel(frame: CGRectMake(15,30,screen.width,20))
            infoLabel.font = UIFont.systemFontOfSize(14)
            switch row {
            case 5:
                nameLabel.text = "QQ"
                infoLabel.text = "\(friendInfo[11])"
            case 6:
                nameLabel.text = "微信"
                infoLabel.text = "\(friendInfo[12])"
            default:
                nameLabel.text = "年级信息"
                infoLabel.text = "\(friendInfo[9])"
            }
            
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
        default:
            return
        }
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.longPress))
        self.addGestureRecognizer(longPressGR)
    }
    
    //0    var usericon:String  *
    //1    var realname:String  *
    //2    var username:String  *
    //3    var phone:String     *
    //4    var nickname:String! -
    //5    var signature:String *
    //6    var classname:String!    *
    //7    var departmentname:String!   *
    //8    var gender:String!   *
    //9    var year:String!     *
    //10   var isRegister:Bool *
    //11   var qq:String!
    //12   var weixin:String!
    
    func copyAction(sender:UIMenuItem){
        switch self.row{
        case 0:
            UIPasteboard.generalPasteboard().string = nameLabel.text! + infoLabel.text!
        case 1,2,3,4,5,6:
            UIPasteboard.generalPasteboard().string = infoLabel.text!
        default:
            break
        }
        print(UIPasteboard.generalPasteboard().string)
    }
    
    func msg(){
        let url = NSURL(string: "sms://\(infoLabel.text!)")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func call(){
        let alert = UIAlertController(title: "", message: "拨打\(infoLabel.text!)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: { (submit) in
            let url = NSURL(string: "tel://\(self.infoLabel.text!)")
            UIApplication.sharedApplication().openURL(url!)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        var next = self.superview
        while next != nil {
            let nextResponder = next!.nextResponder()
            if nextResponder!.isKindOfClass(PeopleDetailVC.classForCoder()){
                (nextResponder as! PeopleDetailVC).presentViewController(alert, animated: true, completion: nil)
            }
            next = next!.superview
        }
        
    }
    
    func setUp(row:Int,friendInfo:NSArray){
        nameLabel.text = friendInfo[1] as? String
        infoLabel.text = "\(friendInfo[8])  \(friendInfo[6])  \(friendInfo[7])"
    }
    
    var touchPosition:CGPoint!
    func longPress(sender:UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Began{
            self.becomeFirstResponder()
            let copyItem = UIMenuItem(title: "复制", action: #selector(self.copyAction(_:)))
            let menu = UIMenuController.sharedMenuController()
            menu.menuItems = [copyItem]
            menu.setTargetRect(CGRectMake(touchPosition.x, touchPosition.y - 10, 0, 0), inView: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == #selector(self.copyAction(_:)){
            return true
        }
        return false
    }
    
    override func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        touchPosition = touch.locationInView(self)
        return true
    }
    
    
    

    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animateWithDuration(0.1) {
            self.backgroundColor = !self.highlighted ? UIColor.clearColor() : Config.mainColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
