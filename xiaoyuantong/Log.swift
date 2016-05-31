//
//  Log.swift
//  Demo
//
//  Created by 谭钧豪 on 16/5/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//
//---------------------------------------------------------------------
//  使用方法：重写viewDidAppear添加一个计时器，计时执行uploadCheck()
//---------------------------------------------------------------------
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        //每隔5秒检查一次
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(5,
//                                                            target: self,
//                                                            selector: #selector(self.uploadCheck),
//                                                            userInfo: nil, repeats: true)
//        //三秒延迟开始计时
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(3000000000)), LOG_QUEUE) {
//            self.timer.fire()
//        }
//        Log.directoryPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)[0]+"/"
//    }
//
//    func uploadCheck(){
//        dispatch_async(LOG_QUEUE) {
//            Log.uploadCheck()
//        }
//    }
//---------------------------------------------------------------------

import Foundation
import UIKit

public class Log:Request{
    ///本次上传次数
    static let count = 0
    ///应用文档储存路径
    static var directoryPaths:String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true)[0]+"/"
    ///上次上传的时间
    static var lastUploadLogTime = NSTimeInterval()
    
    /**
     向日志文件添加一条记录
     -  parameters:
        -   type:   类型
        -   name:   名称
        -   widget: 控件
     */
    public static func add(type:String,name:String,widget:String){
        let time = "\(Int64((NSDate().timeIntervalSince1970 as NSTimeInterval) * 1000))"
        ///准备写入的字符串
        let str = "{\"type\":\""+type+"\",\"name\":\""+name+"\",\"widget\":\""+widget+"\",\"time\":\""+time+"\"}\n"
        
        let fileManager = NSFileManager.defaultManager()
        var fileSize: Int = 0
        var curPath = ""
        if let lastPath = (NSUserDefaults.standardUserDefaults().valueForKey("LastPath") as? String){
            curPath = directoryPaths + lastPath + ".txt"
            do{
                fileSize = try fileManager.attributesOfItemAtPath(curPath)[NSFileSize] as! Int
            }catch{
                print(error)
            }
        }
        if fileManager.isWritableFileAtPath(curPath) && fileSize < 10230{
            let fileHandle = NSFileHandle(forUpdatingAtPath: curPath)!
            fileHandle.seekToEndOfFile()
            fileHandle.writeData(str.dataUsingEncoding(NSUTF8StringEncoding)!)
            fileHandle.closeFile()
        }else{
            curPath = directoryPaths + time + ".txt"
            NSUserDefaults.standardUserDefaults().setValue(time, forKey: "LastPath")
            fileManager.createFileAtPath(curPath, contents: (str).dataUsingEncoding(NSUTF8StringEncoding)!, attributes: nil)
        }
    }
    
    ///上传文件之前的检查，如果符合条件，自动将所有日志文件上传
    public static func uploadCheck(){
        ///遍历filePath目录下所有文件名的集合
        let myDirectoryEnumerator = NSFileManager.defaultManager().enumeratorAtPath(directoryPaths)!.allObjects
        ///当前遍历的文件名
        var removeList = [String]()
        let uuidData = (UIDevice.currentDevice().identifierForVendor?.UUIDString ?? "0").dataUsingEncoding(NSUTF8StringEncoding)!
        let versionData = "1.0".dataUsingEncoding(NSUTF8StringEncoding)!
        for curCount in 0..<myDirectoryEnumerator.count {
            let fileTempName = myDirectoryEnumerator[myDirectoryEnumerator.count-1-curCount]
            if !"\(fileTempName)".hasSuffix(".txt"){
                continue
            }
            if let readData = NSData(contentsOfFile: directoryPaths+"\(fileTempName)") {
                ///当前遍历的文件的大小
                var fileSize = Int()
                do{
                    fileSize = (try NSFileManager.defaultManager().attributesOfItemAtPath(directoryPaths+"\(fileTempName)")[NSFileSize] as! Int)
                    if !(fileSize < 10){
                        let data = Request.appendedData(
                            (uuidData,"deviceId"),
                            (versionData,"version"),
                            ("iOS".dataUsingEncoding(NSUTF8StringEncoding)!,"platform"),
                            (readData,"file\"; filename=\"\(fileTempName)")
                        )
                        if let _ = (NSUserDefaults.standardUserDefaults().valueForKey("LastPath") as? String){
                            NSUserDefaults.standardUserDefaults().removeObjectForKey("LastPath")
                        }
                        if uploadLog(data){
                            removeList.append(directoryPaths+"\(fileTempName)")
                        }
                    }
                }catch{
                    print(error)
                }
            } else {
                print("读取不到数据导致continue")
                continue
            }
        }
        for fileName in removeList{
            do{
                try NSFileManager.defaultManager().removeItemAtPath(fileName)
            }catch{
                print("移除失败,:\(error)")
            }
        }
    }
    
    /**
     -  parameters:
        -   data: HTTPBody
     -  returns:
        -   Bool: 日志是否上传成功
     */
    public static func uploadLog(data:NSMutableData) -> Bool{
        if let returnData = super.request(data, url: NSURL(string: Config.url+"upload-log")!, HTTPMethodIsGet: false,tag:count){
            print(NSString(data: returnData, encoding: NSUTF8StringEncoding))
            let returnStr = NSString(data: returnData, encoding: NSUTF8StringEncoding)! as String
            if returnStr.containsString("成功"){
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
}

