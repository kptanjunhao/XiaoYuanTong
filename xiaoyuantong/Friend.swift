//
//  Friend.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/27.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//
import Foundation
class Friend{
    var usericon:String
    var realname:String
    var username:String
    var phone:String
    var nickname:String!
    var signature:String
    
    var classname:String!
    var departmentname:String!
    var gender:String!
    var year:String!
    var isRegister:Bool
    
    var qq:String!
    var weixin:String!
    
    var selected = false
    
    
    
    
    
    init(friendObj:AnyObject){
        self.isRegister = friendObj.objectForKey("isRegister") as? Bool ?? false
        self.phone = friendObj.objectForKey("phone") as? String ?? "这家伙没有留下电话"
        self.realname = friendObj.objectForKey("realname") as? String ?? "获取姓名失败"
        self.signature = friendObj.objectForKey("signature") as? String ?? "这个家伙很懒，没有留下签名"
        self.username = friendObj.objectForKey("username") as? String ?? "0"
        self.usericon = Config.url + "faces/" + self.username + ".jpg"
    }
    
    
    
    
    init(result:AnyObject){
        self.isRegister = result.objectForKey("isregister") as? Bool ?? false
        self.phone = result.objectForKey("userphone") as? String ?? ""
        self.realname = result.objectForKey("userrealname") as? String ?? "获取姓名失败"
        self.signature = result.objectForKey("usersignature") as? String ?? "这家伙很懒，没有留下签名"
        self.username = result.objectForKey("userid") as? String ?? "0"
        self.usericon = Config.url + "faces/" + self.username + ".jpg"
        self.classname = result.objectForKey("classname") as? String ?? ""
        self.departmentname = result.objectForKey("departmentname") as? String ?? ""
        self.gender = result.objectForKey("gender") as? String ?? ""
        self.nickname = result.objectForKey("nickname") as? String ?? ""
        self.year = result.objectForKey("year") as? String ?? ""
        self.qq = result.objectForKey("userqq") as? String ?? ""
        self.weixin = result.objectForKey("userweixin") as? String ?? ""
    }
    
    func visibleAttrAndValue() -> NSDictionary{
        let mirror = Mirror(reflecting:self)
        let attrAndValue = NSMutableDictionary()
        for case let (attrName,attrValue) in mirror.children {
            attrAndValue.addEntriesFromDictionary([attrName!:attrValue as! AnyObject])
        }
        return attrAndValue
    }
    
    func visibleValue() -> NSMutableArray{
        let mirror = Mirror(reflecting:self)
        let Values = NSMutableArray()
        for case let (_,attrValue) in mirror.children {
            Values.addObject(attrValue as! AnyObject)
        }
        return Values
    }
    
}
