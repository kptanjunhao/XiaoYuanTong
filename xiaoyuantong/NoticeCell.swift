//
//  NoticeCell.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/6/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class NoticeCell: UITableViewCell {
    var noticeStyle:String!
    var msg:Notice!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animateWithDuration(0.1) {
            self.backgroundColor = !self.highlighted ? UIColor.clearColor() : Config.mainColor
        }
    }
    
    func setUp(msg:RecvNotice){
        self.msg = msg
        noticeStyle = "RecvNotice"
        let titleText = NSMutableAttributedString(string: msg.title+" "+msg.time!)
        titleText.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFontOfSize(17), range: NSMakeRange(0, msg.title.characters.count))
        titleText.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(12), range: NSMakeRange(msg.title.characters.count+1, titleText.length-msg.title.characters.count-1))
        titleText.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGrayColor(), range: NSMakeRange(msg.title.characters.count+1, titleText.length-msg.title.characters.count-1))
        
        self.imageView?.image = imageWithIcon(msg.flag ? "\u{e60b}" : "\u{e603}", fontName: "iconfont", size: 30, color: Config.mainColor)
        self.textLabel?.attributedText = titleText
        self.detailTextLabel?.text = msg.noticeFromName
    }
    
    func setUp(msg:SendNotice){
        self.msg = msg
        noticeStyle = "SendNotice"
        self.imageView?.image = imageWithIcon("\u{e603}", fontName: "iconfont", size: 30, color: Config.mainColor)
        self.textLabel?.text = msg.title
        self.detailTextLabel?.text = msg.time
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awake")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
