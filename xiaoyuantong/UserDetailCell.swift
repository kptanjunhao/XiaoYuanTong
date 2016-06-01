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
        nameLabel = UILabel(frame: CGRectMake(15,10,100,20))
        nameLabel.font = UIFont.systemFontOfSize(16)
        nameLabel.textColor = UIColor.lightGrayColor()
        infoLabel = UITextField(frame: CGRectMake(90,10,screen.width-100,20))
        switch row {
        case 0:
            nameLabel.text = "姓名"
            infoLabel.font = UIFont.italicSystemFontOfSize(17)
            infoLabel.text = "\(friendInfo[1])"
            infoLabel.tag = 1
        case 1:
            nameLabel.text = "个性签名"
            infoLabel.font = UIFont.italicSystemFontOfSize(17)
            if (friendInfo[5] as! String) == "这家伙很懒，没有留下签名"{
                infoLabel.text =  ""
                infoLabel.placeholder = (friendInfo[5] as! String)
            }else{
                infoLabel.text = (friendInfo[5] as! String)
            }
            infoLabel.tag = 5
        case 2:
            nameLabel.text = "电话"
            infoLabel.font = UIFont.systemFontOfSize(14)
            infoLabel.text = "\(friendInfo[3])"
            infoLabel.tag = 3
        case 3:
            nameLabel.text = "账号信息"
            infoLabel.enabled = false
            infoLabel.textColor = UIColor.lightGrayColor()
            infoLabel.font = UIFont.systemFontOfSize(17)
            infoLabel.text = "\(friendInfo[2])"
        case 4,5,6:
            infoLabel.font = UIFont.systemFontOfSize(17)
            switch row {
            case 5:
                nameLabel.text = "QQ"
                infoLabel.text = "\(friendInfo[11])"
                infoLabel.tag = 11
            case 6:
                nameLabel.text = "微信"
                infoLabel.text = "\(friendInfo[12])"
                infoLabel.tag = 12
            default:
                nameLabel.text = "年级信息"
                infoLabel.text = (friendInfo[9] as! String) == "" ? "不可用" : friendInfo[9] as! String
                infoLabel.enabled = false
                infoLabel.textColor = UIColor.lightGrayColor()
            }
        default:
            return
        }
        self.addSubview(nameLabel)
        self.addSubview(infoLabel)
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
            if vc.editingTextField.tag != 0{
                vc.textFieldEndEditing(vc.editingTextField.tag)
            }
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
