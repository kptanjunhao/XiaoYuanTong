//
//  Config.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/27.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

public class Config{
    static let mainColor = UIColor(red:0.17, green:0.75, blue:0.90, alpha:1.00)
    static let url = "http://121.42.12.12:8080/xyt/"
    
    static let UPLOAD_LOG_TAG = -1
    static let LOGIN_TAG = 1
    static let GET_GROUPS_TAG = 2
    static let GET_USERINFO_TAG = 3
    static let UPLOADICON_TAG = 4
    static let UPDATE_INFO_TAG = 5
    static let GET_RECMSG_TAG = 6
    static let GET_SENDMSG_TAG = 7
    static let SEND_NOTICE_TAG = 8
    static let LEAVE_MSG_TAG = 9
    static let GET_NOTICEDETAIL_TAG = 10
    
    
}


extension String{
    
    var md5: String! {
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        //!!!!指针的销毁
        result.destroy()
        result.dealloc(digestLen)
        return String(format: hash as String)
    }
    
}

extension UIImageView {
    /**
     *设置web图片
     *url:图片路径
     *defaultImage:默认缺省图片
     *isCache：是否进行缓存的读取
     */
    func setZYHWebImage(url:NSString?, defaultImage:NSString?, isCache:Bool){
        var ZYHImage:UIImage?
        if url == nil {
            return
        }
        //设置默认图片
        if defaultImage != nil {
            self.image=UIImage(named: defaultImage! as String)
        }
        
        if isCache {
            let data:NSData? = ZYHWebImageChcheCenter.readCacheFromUrl(url!)
            if data != nil {
                ZYHImage=UIImage(data: data!)
                self.image=ZYHImage
            }else{
                let dispath=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
                dispatch_async(dispath, { () -> Void in
                    let URL:NSURL = NSURL(string: url! as String)!
                    let data:NSData?=NSData(contentsOfURL: URL)
                    if data != nil {
                        ZYHImage=UIImage(data: data!)
                        //写缓存
                        ZYHWebImageChcheCenter.writeCacheToUrl(url!, data: data!)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            //刷新主UI
                            self.image=ZYHImage
                        })
                    }
                    
                })
            }
        }else{
            let dispath=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
            dispatch_async(dispath, { () -> Void in
                let URL:NSURL = NSURL(string: url! as String)!
                let data:NSData?=NSData(contentsOfURL: URL)
                if data != nil {
                    ZYHImage=UIImage(data: data!)
                    //写缓存
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        //刷新主UI
                        self.image=ZYHImage
                    })
                }
                
            })
        }
    }
    
}


//第三方图片网络缓存
class ZYHWebImageChcheCenter: NSObject {
    class func readCacheFromUrl(url:NSString)->NSData?{
        var data:NSData?
        let path:NSString=ZYHWebImageChcheCenter.getFullCachePathFromUrl(url)
        if NSFileManager.defaultManager().fileExistsAtPath(path as String) {
            //            data=NSData.dataWithContentsOfMappedFile(path as String) as? NSData
            data = NSData(contentsOfFile: path as String)
            
        }
        return data
    }
    
    class func writeCacheToUrl(url:NSString, data:NSData){
        let path:NSString=ZYHWebImageChcheCenter.getFullCachePathFromUrl(url)
        print(data.writeToFile(path as String, atomically: true))
    }
    //设置缓存路径
    class func getFullCachePathFromUrl(url:NSString)->NSString{
        var chchePath=NSHomeDirectory().stringByAppendingString("/Library/Caches/MyCache")
        let fileManager:NSFileManager=NSFileManager.defaultManager()
        fileManager.fileExistsAtPath(chchePath)
        if !(fileManager.fileExistsAtPath(chchePath)) {
            do{
                try fileManager.createDirectoryAtPath(chchePath, withIntermediateDirectories: true, attributes: nil)
            }catch{
                print(error)
            }
        }
        //进行字符串处理
        var newURL:NSString
        newURL=ZYHWebImageChcheCenter.stringToZYHString(url)
        chchePath=chchePath.stringByAppendingFormat("/%@", newURL)
        return chchePath
    }
    //删除缓存
    class func removeAllCache(){
        let chchePath=NSHomeDirectory().stringByAppendingString("/Library/Caches/MyCache")
        let fileManager:NSFileManager=NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(chchePath) {
            do{
                try fileManager.removeItemAtPath(chchePath)
            }catch{
                print(error)
            }
        }
        
    }
    class func stringToZYHString(str:NSString)->NSString{
        let newStr:NSMutableString=NSMutableString()
        for i:NSInteger in 0 ..< str.length {
            let c:unichar=str.characterAtIndex(i)
            if (c>=48&&c<=57)||(c>=65&&c<=90)||(c>=97&&c<=122){
                newStr.appendFormat("%c", c)
            }
        }
        return newStr.copy() as! NSString
        
    }
}