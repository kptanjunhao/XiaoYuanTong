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
    var friendsTemp:[Friend]?
    var isClose = true{
        willSet{
            if newValue{
                friendsTemp = friends
                friends = [Friend]()
            }else{
                if friendsTemp != nil{
                    friends = friendsTemp
                    friendsTemp = nil
                }
            }
        }
    }
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
}
