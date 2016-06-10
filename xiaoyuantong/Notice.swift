//
//  Notice.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/6/1.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import Foundation
class NoticeList{
    var recvList = [RecvNotice]()
    var sendList = [SendNotice]()
    func setRec(result:AnyObject){
        recvList.removeAll()
        let list = result.objectForKey("datas") as! NSArray
        if list.count > 0 {
            for recObject in list{
                let title = recObject.objectForKey("title") as? String ?? "获取标题失败"
                let noticeID = recObject.objectForKey("noticeid") != nil ? "\(recObject.objectForKey("noticeid")!)" : "0"
                let noticeFromName = recObject.objectForKey("noticefromname") as? String ?? "获取发送人失败"
                let time = recObject.objectForKey("time") as? String ?? "获取时间失败"
                var flag = false
                if let flagbool = recObject.objectForKey("flag"){
                    flag = flagbool.boolValue
                }
                let recvNotice = RecvNotice(title: title, noticeID: noticeID, time: time, noticeFromName: noticeFromName, flag: flag)
                recvList.append(recvNotice)
            }
        }else{
            recvList.append(RecvNotice(title: "你还没有接收到的通知噢", noticeID: "", time: "00", noticeFromName: "", flag: false))
        }
    }
    func setSend(result:AnyObject){
        sendList.removeAll()
        let list = result.objectForKey("datas") as! NSArray
        if list.count > 0 {
            for recObject in list{
                let title = recObject.objectForKey("title") as? String ?? "无法获取标题"
                let noticeID = recObject.objectForKey("noticeid") != nil ? "\(recObject.objectForKey("noticeid")!)" : "0"
                let time = recObject.objectForKey("time") as? String ?? "无法获取时间"
                let noticeGroup = recObject.objectForKey("noticegroup") as? String ?? "0"
                let sendNotice = SendNotice(title: title, noticeID: noticeID, time: time, noticeGroup: noticeGroup)
                sendList.append(sendNotice)
            }
        }else{
            sendList.append(SendNotice(title: "你还没有发送过通知噢", noticeID: "", time: "00", noticeGroup: ""))
        }
    }
}
class Notice {
    var title:String
    var noticeID:String?
    var time:String?
    init(title:String,noticeID:String,time:String...){
        self.title = title
        self.noticeID = noticeID
        if time.count != 0{
            self.time = time[0]
        }
    }
}
class RecvNotice:Notice {
    var noticeFromName:String
    var flag:Bool
    init(title: String, noticeID: String, time: String,noticeFromName:String,flag:Bool) {
        self.noticeFromName = noticeFromName
        self.flag = flag
        super.init(title: title, noticeID: noticeID, time: time.substringToIndex(time.endIndex.advancedBy(-2)))
    }
    var noticeText:String?
    var noticeFromUsername:String?
    convenience init(noticeID:String,title:String,noticeText:String,flag:Bool,time:String,noticeFromName:String,noticeFromUsername:String) {
        self.init(title: title, noticeID: noticeID, time: time,noticeFromName:noticeFromName,flag:flag)
        self.noticeText = noticeText
        self.noticeFromUsername = noticeFromUsername
    }
    
}
class SendNotice:Notice {
    var noticeGroup:String
    init(title: String, noticeID: String, time: String,noticeGroup:String) {
        self.noticeGroup = noticeGroup
        super.init(title: title, noticeID: noticeID, time: time.substringToIndex(time.endIndex.advancedBy(-2)))
    }
    var noticeText:String?
    var replyCount:Int?
    var unReplyCount:Int?
    convenience init(title: String, noticeID: String, time: String,noticeGroup:String,noticeText:String,replyCount:Int?,unReplyCount:Int?) {
        self.init(title: title, noticeID: noticeID, time: time,noticeGroup:noticeGroup)
        self.noticeText = noticeText
        self.replyCount = replyCount
        self.unReplyCount = unReplyCount
    }
}
//"person" : sendpeoples,
//"ishasperson" : true,
//"unregister" : "0",
//"status" : "all",
//"username" : username,
//"publish" : [
//"title" : titletf.text!,
//"content" : contenttv.text
//]
