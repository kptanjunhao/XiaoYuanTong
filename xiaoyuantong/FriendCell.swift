//
//  FriendCell.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/27.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signatureLabel: UILabel!
    var friendID:String!
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animateWithDuration(0.1) {
            self.backgroundColor = !self.highlighted ? UIColor.clearColor() : Config.mainColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.clipsToBounds = true
        // Initialization code
    }
    
    func setUp(friend:Friend){
        icon.setZYHWebImage(friend.usericon, defaultImage: "icon", isCache: true)
        nameLabel.text = friend.realname
        signatureLabel.text = friend.signature
        friendID = friend.username
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
