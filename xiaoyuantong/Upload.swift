//
//  Upload.swift
//  Demo
//
//  Created by 谭钧豪 on 16/5/7.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import Foundation

///日志队列
let LOG_QUEUE = dispatch_queue_create("LogQueue", DISPATCH_QUEUE_SERIAL)


public class Request {
    public static let session = NSURLSession.sharedSession()
    ///存放网络请求任务，以便取消或者其他操作
    public static var tasks = [Int:NSURLSessionDataTask]()
    
    public static func request(httpBody:NSMutableData?, url:NSURL, HTTPMethodIsGet:Bool, tag:Int) -> NSData?{
        if HTTPMethodIsGet{
            return self.getRequest(url.absoluteString, requestTimeOut: 5, tag: tag)
        }else{
            return self.postRequest(httpBody, url: url, requestTimeOut: 5, tag: tag)
        }
    }
    
    /**
     放到异步线程中执行，不然会导致UI假死。
     - parameters:
        -   httpBody: NSMutableData类型的数据，分隔符AaB03x
        -   url:    NSURL类型，目标地址
        -   HTTPMethodIsGet:    Bool类型，代表是否GET方法请求
        -   requestTimeOut: 请求超时设置
        -   tag:    请求任务的tag，用于可取消任务时取出请求任务来取消
     - returns:
        NSData类型，服务器返回的数据
     */
    public static func postRequest(httpBody:NSMutableData?, url:NSURL, requestTimeOut:NSTimeInterval, tag:Int) -> NSData?{
        let semaphore = dispatch_semaphore_create(0)
        let request = NSMutableURLRequest(URL: url)
        request.timeoutInterval = requestTimeOut
        request.HTTPMethod = "POST"
        request.addValue("multipart/form-data; boundary=AaB03x", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = httpBody
        var returnData: NSData?
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, resperror) -> Void in
            if resperror != nil{
                print(resperror!)
                returnData = resperror!.userInfo[NSLocalizedDescriptionKey]?.dataUsingEncoding(NSUTF8StringEncoding)!
            }else{
                returnData = data
            }
            dispatch_semaphore_signal(semaphore)
            
        })
        tasks[tag] = dataTask
        dataTask.resume()//启动线程
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        return returnData
        
    }
    
    /**
     放到异步线程中执行，不然会导致UI假死。
     - parameters:
        -   urlstr: url+接口
        -   requestTimeOut: 请求超时设置
        -   tag:    请求任务的tag，用于可取消任务时取出请求任务来取消
        -   parameters: ("关键字","值")...[可选]
     - returns:
     NSData类型，服务器返回的数据.若出错，则返回NSLocalizedDescriptionKey错误信息
     */
    public static func getRequest(urlstr:String, requestTimeOut:NSTimeInterval, tag:Int, parameters:(String,String)...) -> NSData?{
        let semaphore = dispatch_semaphore_create(0)
        var finalurl = urlstr
        if parameters.count != 0{
            finalurl += "?"
            for parameter in parameters{
                finalurl += "\(parameter.0)=\(parameter.1)"
                if parameter != parameters[parameters.count - 1]{
                    finalurl += "&"
                }
            }
        }else{
            
        }
        print(finalurl)
        let url = NSURL(string: finalurl)!
        let request = NSMutableURLRequest(URL: url)
        request.timeoutInterval = requestTimeOut
        var returnData: NSData?
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, resperror) -> Void in
            if resperror != nil{
                print(resperror!)
                returnData = resperror!.userInfo[NSLocalizedDescriptionKey]?.dataUsingEncoding(NSUTF8StringEncoding)!
            }else{
                returnData = data
            }
            dispatch_semaphore_signal(semaphore)
            
        })
        tasks[tag] = dataTask
        dataTask.resume()//启动线程
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        return returnData
        
    }
    
    public static func getRequestByFiltering(urlstr:String, requestTimeOut:NSTimeInterval, tag:Int, parameters:(String,String)...) -> NSData?{
        let semaphore = dispatch_semaphore_create(0)
        var finalurl = urlstr
        if parameters.count != 0{
            finalurl += "?"
            for parameter in parameters{
                finalurl += "\(parameter.0)=\(parameter.1)"
                if parameter != parameters[parameters.count - 1]{
                    finalurl += "&"
                }
            }
        }else{
            
        }
        print("Filtering"+finalurl)
        finalurl = finalurl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
        let url = NSURL(string: finalurl)!
        let request = NSMutableURLRequest(URL: url)
        request.timeoutInterval = requestTimeOut
        var returnData: NSData?
        let dataTask = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, resperror) -> Void in
            if resperror != nil{
                print(resperror!)
                returnData = resperror!.userInfo[NSLocalizedDescriptionKey]?.dataUsingEncoding(NSUTF8StringEncoding)!
            }else{
                returnData = data
            }
            dispatch_semaphore_signal(semaphore)
            
        })
        tasks[tag] = dataTask
        dataTask.resume()//启动线程
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)//等待线程结束
        return returnData
        
    }
    
    
    
    public static func getRequestXYTFormat(urlstr:String, requestTimeOut:NSTimeInterval, tag:Int, datas:(String,String)...) -> NSData?{
        var parameter = "{"
        for data in datas{
            parameter.appendContentsOf("\"\(data.0)\":\"\(data.1)\",")
        }
        parameter.removeAtIndex(parameter.characters.endIndex.advancedBy(-1))
        parameter.appendContentsOf("}")
        return self.getRequest(urlstr+"?data="+parameter.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!, requestTimeOut: requestTimeOut, tag: tag)
    }
    
    //  \"; key=\"key值
    /**
     -  parameters:
        -   datas:(NSData,String)元组类型，NSData为数据，String为表单中的name属性<br/>若需要多个属性，则添加  (name值\\"; key=\\"key值)这样格式的字符串
     -  returns:
        -   NSMutableData添加分隔符之后的数据
     */
    public static func appendedData(datas:(NSData,String)...) -> NSMutableData{
        let appendedData = NSMutableData()
        for data in datas{
            appendedData.appendData(NSString(string: "\r\n--AaB03x\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            appendedData.appendData(NSString(string: "content-disposition: form-data; name=\"\(data.1)\"\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
            appendedData.appendData(data.0)
        }
        appendedData.appendData(NSString(string: "\r\n--AaB03x--\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        return appendedData
    }
}