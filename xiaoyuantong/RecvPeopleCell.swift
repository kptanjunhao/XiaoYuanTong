//
//  RecvPeopleCell.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/6/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class RecvPeopleCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var selectedIconLabel: UILabel!
    
    var vc:CreateNoticeVC!
    var friend:Friend!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        selectedIconLabel.font = UIFont(name: "iconfont", size: 18)
        selectedIconLabel.layer.cornerRadius = selectedIconLabel.frame.width/2
        selectedIconLabel.textColor = Config.mainColor
        selectedIconLabel.textAlignment = .Center
        selectedIconLabel.text = ""
        selectedIconLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        // Initialization code
    }
    
    func selectPeople(){
        self.friend.selected = !self.friend.selected
        if self.friend.selected{
            vc.selectedUsername.append(self.friend.username)
            selectedIconLabel.text = "\u{e610}"
            selectedIconLabel.layer.borderWidth = 0
        }else{
            if let index = vc.selectedUsername.indexOf(self.friend.username){
                vc.selectedUsername.removeAtIndex(index)
                selectedIconLabel.text = ""
                selectedIconLabel.layer.borderWidth = 1
            }
        }
    }
    
    func setUp(friend:Friend,vc:CreateNoticeVC){
        self.friend = friend
        self.vc = vc
        nameLabel.text = friend.realname
        iconImageView.setZYHWebImage(friend.usericon, defaultImage: "loading", isCache: true)
        if self.friend.selected{
            selectedIconLabel.text = "\u{e610}"
            selectedIconLabel.layer.borderWidth = 0
        }else{
            selectedIconLabel.text = ""
            selectedIconLabel.layer.borderWidth = 1
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animateWithDuration(0.1) {
            self.backgroundColor = !self.highlighted ? UIColor.clearColor() : Config.mainColor
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
