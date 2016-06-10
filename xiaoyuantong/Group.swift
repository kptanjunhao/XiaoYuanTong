//
//  Group.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/27.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import Foundation

class Group{
    
    var groupName:String
    var registerCount:Int
    var totleCount:Int
    var friends:[Friend]?
    var isClose = true
//    var isClose = true{
//        willSet{
//            if newValue{
//                friendsTemp = friends
//                friends = [Friend]()
//            }else{
//                if friendsTemp != nil{
//                    friends = friendsTemp
//                    friendsTemp = nil
//                }
//            }
//        }
//    }
    var selected = false
    init(groupName:AnyObject){
        self.groupName = groupName.objectForKey("groupName") as! String
        self.registerCount = groupName.objectForKey("registerCount") as? Int ?? 0
        self.totleCount = groupName.objectForKey("totleCount") as? Int ?? 0
    }
    
    func getFriends(result:AnyObject){
        self.friends = [Friend]()
        let friends = result.objectForKey(self.groupName) as? NSMutableArray ?? NSMutableArray()
        for friend in friends{
            self.friends?.append(Friend.init(friendObj: friend))
        }
    }
    
    func getFriend(username:String) -> Friend?{
        if friends == nil{
            return nil
        }else{
            for friend in friends!{
                if friend.username == username{
                    return friend
                }
            }
        }
        return nil
    }
}

class GroupList{
    var groups:[Group]
    
    init(result:AnyObject){
        self.groups = [Group]()
        let groupsNameList = result.objectForKey("groupNameList") as? NSArray ?? NSArray()
        for groupName in groupsNameList{
            let group = Group(groupName: groupName)
            group.getFriends(result)
            self.groups.append(group)
        }
    }
    
    func getFriend(username:String) -> Friend?{
        for group in groups{
            if let friend = group.getFriend(username){
                return friend
            }
        }
        return nil
    }
    
    func getRealnameByUsername(username:String) -> String?{
        return self.getFriend(username)?.realname
    }
    
    func getRealnameByUsername(usernames:[String]) -> [String]{
        var realnames = [String]()
        for username in usernames{
            realnames.append(self.getFriend(username)?.realname ?? username)
        }
        return realnames
    }
}
