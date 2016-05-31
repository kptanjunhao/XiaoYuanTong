//
//  UserDetailCell.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/31.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class UserDetailCell: UITableViewCell {
    
    var row:Int = 0
    var nameLabel:UILabel!
    var infoLabel:UITextField!
    var vc:PeopleDetailVC!
    
    
    init(row:Int,friendInfo:NSArray,vc:PeopleDetailVC){
        self.row = row
        self.vc = vc
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        switch row {
        case 0:
            nameLabel = UILabel(frame: CGRectMake(15,10,40,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.text = "姓名"
            nameLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UITextField(frame: CGRectMake(90,10,screen.width-100,20))
            infoLabel.font = UIFont.italicSystemFontOfSize(17)
            infoLabel.text = "\(friendInfo[1])"
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
        case 1:
            nameLabel = UILabel(frame: CGRectMake(15,10,100,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.text = "个性签名"
            nameLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UITextField(frame: CGRectMake(90,10,screen.width-100,20))
            infoLabel.font = UIFont.italicSystemFontOfSize(17)
            infoLabel.text = "\(friendInfo[5])"
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
        case 2:
            nameLabel = UILabel(frame: CGRectMake(15,10,40,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.text = "电话"
            nameLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UITextField(frame: CGRectMake(90,10,screen.width-100,20))
            infoLabel.font = UIFont.systemFontOfSize(14)
            infoLabel.text = "\(friendInfo[3])"
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
        case 3:
            nameLabel = UILabel(frame: CGRectMake(15,10,100,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.text = "账号信息"
            nameLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UITextField(frame: CGRectMake(90,10,screen.width-100,20))
            infoLabel.enabled = false
            infoLabel.textColor = UIColor.lightGrayColor()
            infoLabel.font = UIFont.systemFontOfSize(17)
            infoLabel.text = "\(friendInfo[2])"
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
        case 4,5,6:
            nameLabel = UILabel(frame: CGRectMake(15,10,100,20))
            nameLabel.font = UIFont.systemFontOfSize(16)
            nameLabel.textColor = UIColor.lightGrayColor()
            infoLabel = UITextField(frame: CGRectMake(90,10,screen.width-100,20))
            infoLabel.font = UIFont.systemFontOfSize(17)
            switch row {
            case 5:
                nameLabel.text = "QQ"
                infoLabel.text = "\(friendInfo[11])"
                if infoLabel.text! == "这家伙没有填QQ号"{
                    infoLabel.text = ""
                }
            case 6:
                nameLabel.text = "微信"
                infoLabel.text = "\(friendInfo[12])"
                if infoLabel.text! == "这家伙没有填微信号"{
                    infoLabel.text = ""
                }
            default:
                nameLabel.text = "年级信息"
                infoLabel.text = "\(friendInfo[9])"
                infoLabel.enabled = false
                infoLabel.textColor = UIColor.lightGrayColor()
            }
            
            self.addSubview(nameLabel)
            self.addSubview(infoLabel)
        default:
            return
        }
        infoLabel.delegate = vc
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
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if vc.editingTextField != nil{
            vc.editingTextField.resignFirstResponder()
            vc.editingTextField = nil
        }
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
