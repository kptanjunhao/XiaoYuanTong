//
//  LoginVC.swift
//  Demo
//
//  Created by 谭钧豪 on 16/5/7.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

let screen = UIScreen.mainScreen().bounds
///登录界面
class LoginNC: UINavigationController {
    //|--- 导航栏设置 ---|
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    /**
     登录界面初始化
     -  parameters:
        -   background  :   UIColor? 登录界面背景颜色<br/>若nil，默认为#EEE
     */
    init(background:UIColor?){
        super.init(rootViewController: LoginVC(background: background))
        self.navigationBar.translucent = false
        self.navigationBar.barTintColor = Config.mainColor//设置导航栏背景颜色
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]//导航栏文字颜色
//        self.navigationBar.titleTextAttributes = [NSFontAttributeName:UIFont.systemFontOfSize(20)]//导航栏文字样式
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    
}
///登录界面
class LoginVC: UIViewController, UITextFieldDelegate {
    
    
    var background: UIColor?
    var nameTF: UITextField!
    var passwordTF: UITextField!
    var nameTFFrame: CGRect!
    var passwordTFFrame: CGRect!
    /**
     登录界面初始化
     -  parameters:
     -   background  :   UIColor? 登录界面背景颜色<br/>若nil，默认为#EEE
     */
    init(background: UIColor?){
        super.init(nibName: nil, bundle: nil)
        if let _ = background{
            self.background = background
        }else{
            self.background = UIColor(red:0.9375, green:0.9375, blue:0.9375, alpha:1.00)
        }
        self.title = "登录"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func cancel(){
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "isLogin")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = background
        self.setupTextField()
        self.setupButton()
        
        let item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = item
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSUserDefaults.standardUserDefaults().setValue(false, forKey: "isLogin")
    }
    //MARK: 界面设置
    
    ///文本框设置
    func setupTextField(){
        nameTFFrame = CGRectMake(-1,screen.height/3 - 20,screen.width+2,44)
        passwordTFFrame = CGRectMake(-1,screen.height/3 + 40,screen.width+2,44)
        
        nameTF = UITextField(frame: nameTFFrame)
        passwordTF = UITextField(frame: passwordTFFrame)
        
        nameTF.placeholder = "请输入用户名"
        passwordTF.placeholder = "请输入密码"
        
        nameTF.delegate = self
        passwordTF.delegate = self
        
        nameTF.textAlignment = .Center
        passwordTF.textAlignment = .Center
        nameTF.returnKeyType = .Next
        passwordTF.returnKeyType = .Done
        nameTF.autocorrectionType = UITextAutocorrectionType.No
        passwordTF.secureTextEntry = true
        
        nameTF.backgroundColor = UIColor.whiteColor()
        passwordTF.backgroundColor = UIColor.whiteColor()
        nameTF.layer.borderColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1).CGColor
        passwordTF.layer.borderColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1).CGColor
        nameTF.layer.borderWidth = 1
        passwordTF.layer.borderWidth = 1
        
        self.view.addSubview(nameTF)
        self.view.addSubview(passwordTF)
    }
    
    ///按钮设置
    func setupButton(){
        let loginBtn = UIButton(type: UIButtonType.RoundedRect)
        loginBtn.frame = CGRectMake(screen.width/4,passwordTFFrame.origin.y + passwordTFFrame.height + 17,screen.width/2,42)
        loginBtn.backgroundColor = Config.mainColor
        loginBtn.setTitle("登录", forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        loginBtn.setTitleColor(UIColor.grayColor(), forState: UIControlState.Highlighted)
        loginBtn.addTarget(self, action: #selector(self.loginDetect), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(loginBtn)
    }
    
    /**
     摇动一个文本框
     -  parameters:
        -   sender  :   UITextField 需要摇动的文本框对象
     */
    func shade(sender:UITextField){
        sender.becomeFirstResponder()
        UIView.animateWithDuration(0.1, animations: {
            sender.frame.origin.x -= 10
            }, completion: { (complete) in
                UIView.animateWithDuration(0.1, animations: {
                    sender.frame.origin.x += 20
                    }, completion: { (complete) in
                        UIView.animateWithDuration(0.1, animations: {
                            sender.frame.origin.x -= 10
                        }, completion: { (complete) in
                            
                        })
                })
        })
    }
    

    
    var loginStatu = false
    ///监测文本框是否符合条件可以向服务器请求登录
    func loginDetect(){
        dispatch_async(LOG_QUEUE) {
            Log.add("Press", name: "点击登录", widget: "UIButton")
        }
        if passwordTF.text! == ""{
            loginStatu = false
            shade(passwordTF)
        }
        if nameTF.text! == ""{
            loginStatu = false
            shade(nameTF)
        }
        if nameTF.text! != "" && passwordTF.text! != ""{
            loginStatu = true
        }
        if loginStatu{
            loginRequest()
        }
    }
    ///向服务器发起登录请求
    func loginRequest(){
        dispatch_async(LOG_QUEUE) {
            Log.add("Press", name: "访问登录", widget: "UIButton")
        }
        //取消所有文本框光标
        self.nameTF.resignFirstResponder()
        self.passwordTF.resignFirstResponder()
        
        let username = nameTF.text!
        let password = passwordTF.text!
        //提醒用户正在登录，并提供取消登录
        var alert = UIAlertController(title: "提醒", message: "正在登录" , preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: { (action) in
            dispatch_async(LOG_QUEUE) {
                Log.add("Press", name: "取消登录", widget: "UIAlertAction")
            }
            Request.tasks[-9]!.cancel()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
        //异步开始发送网络请求
        dispatch_async(dispatch_get_global_queue(-2, 0)) {
            let data = Request.getRequestXYTFormat(Config.url+"login", requestTimeOut: 5, tag: Config.LOGIN_TAG, datas: ("username", username),("password",password))
            dispatch_sync(dispatch_get_main_queue(), {
                alert.dismissViewControllerAnimated(true, completion: {
                    if let nsstr = NSString(data: data!, encoding: NSUTF8StringEncoding){
                        let str = nsstr as String
                        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: "username")
                        if str.containsString("status"){
                            let msg = str.componentsSeparatedByString("status\":\"")[1].componentsSeparatedByString("\"}")[0]
                            var alertmsg = ""
                            if msg == "1"{
                                alertmsg = "登录成功"
                            }else{
                                alertmsg = "用户名或密码错误"
                            }
                            alert = UIAlertController(title: "", message: alertmsg, preferredStyle: UIAlertControllerStyle.Alert)
                            self.presentViewController(alert, animated: true, completion: nil)
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1500000000), dispatch_get_main_queue(), {
                                alert.dismissViewControllerAnimated(true, completion: {
                                    if msg.containsString("1"){
                                        NSUserDefaults.standardUserDefaults().setValue(true, forKey: "isLogin")
                                        NSUserDefaults.standardUserDefaults().setValue(username, forKey: "username")
                                        NSNotificationCenter.defaultCenter().postNotificationName("loginSuccess", object: nil)
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                })
                            })
                        }else{
                            alert = UIAlertController(title: "", message: str, preferredStyle: UIAlertControllerStyle.Alert)
                            self.presentViewController(alert, animated: true, completion: nil)
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1500000000), dispatch_get_main_queue(), {
                                alert.dismissViewControllerAnimated(true, completion: nil)
                            })
                        }
                    }else{
                        alert = UIAlertController(title: "", message: "网络异常", preferredStyle: UIAlertControllerStyle.Alert)
                        self.presentViewController(alert, animated: true, completion: nil)
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1500000000), dispatch_get_main_queue(), {
                            alert.dismissViewControllerAnimated(true, completion: nil)
                        })
                    }
                    
                })
            })
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == nameTF{
            self.passwordTF.becomeFirstResponder()
        }else if textField == passwordTF{
            self.passwordTF.resignFirstResponder()
            self.loginDetect()
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.passwordTF.resignFirstResponder()
        self.nameTF.resignFirstResponder()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

