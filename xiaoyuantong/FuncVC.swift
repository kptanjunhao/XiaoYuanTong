//
//  AssignVC.swift
//  SchoolBangBang
//
//  Created by 谭钧豪 on 16/5/14.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit
import CoreLocation

class UIPressGestureRecognizer:UILongPressGestureRecognizer{
    override init(target: AnyObject?, action: Selector) {
        super.init(target: target, action: action)
        self.minimumPressDuration = 0.00000001
    }
}

class FuncVC: MainVC,CLLocationManagerDelegate {
    let locationmanager = CLLocationManager()
    var lat:CLLocationDegrees?
    var lon:CLLocationDegrees?
    var weather:UITextView?
    var weatherIconLabel:UILabel?
    
    init(){
        super.init(nibName: nil, bg: UIColor(red: 0.9375, green: 0.9375, blue: 0.9375, alpha: 1))
        
        self.title = "功能"
        self.tabBarItem.image = imageWithIcon("\u{e606}", fontName: "iconfont", size: 34, color: UIColor.blackColor())
        self.tabBarItem.selectedImage = imageWithIcon("\u{e607}", fontName: "iconfont", size: 34, color: UIColor.blackColor())
        self.tabBarItem.title = "功能"
        
        let aBtn = MenuButton(target: self, title: "菜单1", selector: #selector(self.hi(_:)))
        
        addMenuView(aBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(nibName: nil, bg: UIColor.clearColor())
    }
    
    
    func hi(sender:MenuButton){
        do{
            try self.menuView?.deleteItem(sender)
        }catch{
            print(error)
        }
    }
    
    let scheduleView = UIImageView(image: UIImage(named: "blue"))
    let scoreView = UIImageView(image: UIImage(named: "green"))
    let cetView = UIImageView(image: UIImage(named: "purple"))
    let weatherView = UIImageView(image: UIImage(named: "orange"))
    
    var SCHEDULE_TAG = 101
    var SCORE_TAG = 102
    var CET_TAG = 103

    override func viewDidLoad() {
        super.viewDidLoad()
        let hbButton = UIButton(frame: CGRectMake(0,0,30,30))
        hbButton.setTitle("\u{e605}", forState: UIControlState.Normal)
        hbButton.setTitle("\u{e604}", forState: UIControlState.Highlighted)
        hbButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        hbButton.addTarget(self, action: #selector(self.showMenu), forControlEvents: UIControlEvents.TouchUpInside)
        hbButton.titleLabel?.font = UIFont(name: "iconfont", size: 30)
        let hbItem = UIBarButtonItem(customView: hbButton)
        self.navigationItem.rightBarButtonItem = hbItem
        
        setZeroFrame()
        setShadow(false,views: scheduleView,scoreView,cetView,weatherView)
        
        scheduleView.userInteractionEnabled = true
        scoreView.userInteractionEnabled = true
        cetView.userInteractionEnabled = true
        weatherView.userInteractionEnabled = true
        
        
        locationmanager.delegate = self
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.requestAlwaysAuthorization()

        scheduleView.tag = SCHEDULE_TAG
        scheduleView.addGestureRecognizer(UIPressGestureRecognizer(target: self, action: #selector(self.tapShadow(_:))))
        let scheduleIconLabel = UILabel(frame: CGRectMake(0,screen.width/4-55,screen.width/2-30,60))
        scheduleIconLabel.textColor = UIColor.whiteColor()
        scheduleIconLabel.font = UIFont(name: "iconfont", size: 44)
        scheduleIconLabel.textAlignment = .Center
        scheduleIconLabel.text = "\u{e616}"
        scheduleView.addSubview(scheduleIconLabel)
        let scheduleTextLabel = UITextView(frame: CGRectMake(0,screen.width/2-105,screen.width/2-30,30))
        scheduleTextLabel.text = "查课表"
        scheduleTextLabel.backgroundColor = UIColor.clearColor()
        scheduleTextLabel.textColor = UIColor.whiteColor()
        scheduleTextLabel.textAlignment = .Center
        scheduleTextLabel.userInteractionEnabled = false
        scheduleTextLabel.font = UIFont.systemFontOfSize(14)
        scheduleView.addSubview(scheduleTextLabel)
        
        scoreView.tag = SCORE_TAG
        scoreView.addGestureRecognizer(UIPressGestureRecognizer(target: self, action: #selector(self.tapShadow(_:))))
        let scoreIconLabel = UILabel(frame: CGRectMake(0,screen.width/4-55,screen.width/2-30,60))
        scoreIconLabel.textColor = UIColor.whiteColor()
        scoreIconLabel.font = UIFont(name: "iconfont", size: 44)
        scoreIconLabel.textAlignment = .Center
        scoreIconLabel.text = "\u{e617}"
        scoreView.addSubview(scoreIconLabel)
        let scoreTextLabel = UITextView(frame: CGRectMake(0,screen.width/2-105,screen.width/2-30,30))
        scoreTextLabel.text = "查分数"
        scoreTextLabel.backgroundColor = UIColor.clearColor()
        scoreTextLabel.textColor = UIColor.whiteColor()
        scoreTextLabel.textAlignment = .Center
        scoreTextLabel.userInteractionEnabled = false
        scoreTextLabel.font = UIFont.systemFontOfSize(14)
        scoreView.addSubview(scoreTextLabel)
        
        
        cetView.tag = CET_TAG
        cetView.addGestureRecognizer(UIPressGestureRecognizer(target: self, action: #selector(self.tapShadow(_:))))
        let cetIconLabel = UILabel(frame: CGRectMake(0,screen.width/4-55,screen.width/2-30,60))
        cetIconLabel.textColor = UIColor.whiteColor()
        cetIconLabel.font = UIFont(name: "iconfont", size: 44)
        cetIconLabel.textAlignment = .Center
        cetIconLabel.text = "\u{e614}"
        cetView.addSubview(cetIconLabel)
        let cetTextLabel = UITextView(frame: CGRectMake(0,screen.width/2-105,screen.width/2-30,30))
        cetTextLabel.text = "查 CET "
        cetTextLabel.backgroundColor = UIColor.clearColor()
        cetTextLabel.textColor = UIColor.whiteColor()
        cetTextLabel.textAlignment = .Center
        cetTextLabel.userInteractionEnabled = false
        cetTextLabel.font = UIFont.systemFontOfSize(14)
        cetView.addSubview(cetTextLabel)
        
        
        weatherView.addGestureRecognizer(UIPressGestureRecognizer(target: self, action: #selector(self.getWeather(_:))))
        
        weather = UITextView(frame: CGRectMake(0,screen.width/2-105,screen.width/2-30,90))
        weather?.text = "查天气"
        weather?.backgroundColor = UIColor.clearColor()
        weather?.textColor = UIColor.whiteColor()
        weather?.textAlignment = .Center
        weather?.userInteractionEnabled = false
        weather?.font = UIFont.systemFontOfSize(14)
        weatherView.addSubview(weather!)
        
        weatherIconLabel = UILabel(frame: CGRectMake(0,screen.width/4-55,screen.width/2-30,60))
        weatherIconLabel?.textColor = UIColor.whiteColor()
        weatherIconLabel?.font = UIFont(name: "iconfont", size: 44)
        weatherIconLabel?.textAlignment = .Center
        weatherIconLabel?.text = "\u{e613}"
        weatherView.addSubview(weatherIconLabel!)
        
        self.view.addSubview(scheduleView)
        self.view.addSubview(scoreView)
        self.view.addSubview(cetView)
        self.view.addSubview(weatherView)
    }
    
    func getWeather(sender:UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Began{
            setShadow(true,views:sender.view as! UIImageView)
        }else{
            setShadow(false,views:sender.view as! UIImageView)
            locationmanager.startUpdatingLocation()
        }
    }
    
    func tapShadow(sender:UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.Began{
            setShadow(true,views:sender.view as! UIImageView)
        }else{
            setShadow(false,views:sender.view as! UIImageView)
            self.alert(sender.view as! UIImageView)
        }
    }
    
    var alertStatu = false
    func alert(sender:UIImageView){
        if alertStatu{
            return
        }
        alertStatu = true
        let tag = sender.tag
        var message:String
        var textField1PlaceHolder:String
        var textField2PlaceHolder:String
        switch tag {
        case SCHEDULE_TAG,SCORE_TAG:
            message = "请输入教务系统账号密码"
            textField1PlaceHolder = "请输入账户名"
            textField2PlaceHolder = "请输入密码"
        case CET_TAG:
            message = "请输入CET准考证号及姓名"
            textField1PlaceHolder = "请输入准考证号"
            textField2PlaceHolder = "请输入姓名"
        default:
            print(tag)
            return
        }
        
        let alertController = UIAlertController(title: "提示", message: message, preferredStyle: UIAlertControllerStyle.Alert)

        alertController.addTextFieldWithConfigurationHandler { textField1 in
            if textField1PlaceHolder == "请输入准考证号"{
                textField1.keyboardType = UIKeyboardType.NumberPad
            }
            textField1.placeholder = textField1PlaceHolder
        }
        alertController.addTextFieldWithConfigurationHandler { textField2 in
            textField2.placeholder = textField2PlaceHolder
            if textField2PlaceHolder != "请输入姓名"{
                textField2.secureTextEntry = true
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:{
            _ in
            self.alertStatu = false
        })
        let okAction = UIAlertAction(title: "查询", style: UIAlertActionStyle.Default) {
            _ in
            self.alertStatu = false
            let text1 = alertController.textFields![0].text!
            let text2 = alertController.textFields![1].text!
            self.check(tag,text1:text1,text2: text2)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func check(tag:Int,text1:String,text2:String){
        
        switch tag {
        case self.SCHEDULE_TAG:
            self.getCourse(text1, pwd: text2)
        case self.SCORE_TAG:
            self.getScore(text1, pwd: text2)
        case self.CET_TAG:
            print(tag)
        default:
            print(tag)
            return
        }
    }
    
    
   
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            locationmanager.stopUpdatingLocation()
            //防止暴力点击
            self.classForCoder.cancelPreviousPerformRequestsWithTarget(self, selector: #selector(self.setWeatherInfo), object: nil)
            self.performSelector(#selector(self.setWeatherInfo), withObject: nil, afterDelay: 0.5)
        }
    }
    
    func setWeatherInfo(){
        weather?.text = "正在加载当前位置天气"
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let cityName = self.getCityName()
            let data = Request.getRequestByFiltering("http://api.openweathermap.org/data/2.5/weather", requestTimeOut: 10, tag: 0, parameters: ("lat","\(self.lat!)"),("lon","\(self.lon!)"),("appid","6516f3c8af1e6d6a66d05b891a3530f6"))
            var weatherText = String()
            do{
                let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                if let main = jsonResult["main"] as? NSDictionary{
                    if let tempResult = main["temp"] as? Double{
                        var temperature:Double
                        let country = (jsonResult["sys"] as! NSDictionary)["country"] as! String
                        if let weathername = ((jsonResult["weather"] as! NSArray)[0] as! NSDictionary)["description"] as? String{
                            if (country == "CN"){
                                temperature = tempResult - 273.15
                                weatherText = self.enStringToCN(weathername) + "\n温度:" + String(format: "%.2f",temperature)+"°C"
                                
                            }else{
                                var tempStr = ""
                                if country == "US"{
                                    temperature = ((tempResult - 273.15)*1.8)+32
                                    tempStr = String(format: "%.2f",temperature)+"°F (\(String(format: "%.2f",tempResult - 273.15)+"°C"))"
                                }else{
                                    temperature = tempResult - 273.15
                                    tempStr = String(format: "%.2f",temperature)+"°C"
                                }
                                weatherText = weathername + "\ntemperature:" + tempStr
                            }
                            
                        }else{
                            weatherText = "无法获取气象信息"
                        }
                    }
                }
            }catch{
                let error = error as NSError
                weatherText = error.localizedDescription
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.weather?.text = cityName + "\n" + weatherText
            })
            
            
        }
        
    }
    
    func getcet(id:String,name:String){
        do{
            var strUrl = "cet?data={\"id\":\"\(id)\",\"name\":\"\(name)\"}"
            strUrl = Config.url + strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string:strUrl)
            let data = try NSData(contentsOfURL:url!,options: NSDataReadingOptions())
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let statu = String(json.objectForKey("status")!)
            if statu=="success"{
                let result = json as! NSDictionary
                var longstr = ""
                for key in result.allKeys{
                    longstr = longstr+String(key)+":"+String(result[String(key)]!)+"\n"
                }
                
                self.warnalert(longstr)
            }else{
                self.warnalert("查询失败，请检查输入的信息")
            }
        }catch{
            self.warnalert("访问时遇到未知错误！")
        }
    }
    
    //获取分数并跳转
    func getScore(id:String,pwd:String){
        do{
            var strUrl = "score?data={\"username\":\"\(id)\",\"password\":\"\(pwd)\"}"
            strUrl = Config.url + strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string:strUrl)
            let data = try NSData(contentsOfURL:url!,options: NSDataReadingOptions())
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let statu = String(json.objectForKey("status")!)
            if statu=="success"{
                self.navigationController?.pushViewController(ScoreVC(json:json), animated: true)
            }else{
                self.warnalert("用户名或密码错误")
            }
        }catch{
            self.warnalert("访问时遇到未知错误！")
            print(error)
        }
    }
    
    func getCourse(id:String,pwd:String){
        do{
            var strUrl = "course?data={\"username\":\"\(id)\",\"password\":\"\(pwd)\"}"
            strUrl = Config.url + strUrl.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            let url = NSURL(string:strUrl)
            let data = try NSData(contentsOfURL:url!,options: NSDataReadingOptions())
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments)
            let statu = String(json.objectForKey("status")!)
            if statu=="success"{
                self.navigationController?.pushViewController(ScheduleVC(json:json), animated: true)
            }else{
                self.warnalert("用户名或密码错误")
            }
        }catch{
            self.warnalert("访问时遇到未知错误！")
            print(error)
        }
    }
    
    func warnalert(message:String){
        let alert = UIAlertController(title: "提示", message: message, preferredStyle: .Alert)
        let ok = UIAlertAction(title: "好", style: .Default, handler: nil)
        alert.addAction(ok)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func enStringToCN(en:String) -> String{
        //百度翻译API
        var cn = en
        let appid = "20160203000010824"
        let salt = "1435660288"
        let transkey = "XOIVTtBjZdaOsoXvoIKv"

        let sign = appid+en+salt+transkey
        let sign_md5 = sign.md5

        let url = "http://api.fanyi.baidu.com/api/trans/vip/translate/"
        let data = Request.getRequestByFiltering(url, requestTimeOut: 5, tag: 0, parameters: ("q",en),
            ("from","en"),
            ("to","zh"),
            ("appid",appid),
            ("salt",salt),
            ("sign",sign_md5))
        do{
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            if let result = ((jsonResult["trans_result"] as! NSArray)[0] as! NSDictionary)["dst"] as? String{
                cn = result
            }
        }catch{
            print(error)
        }
        return cn
    }
    
    func getCityName() -> String{
        //百度地图反编译经纬度获取城市名
        var city:String?
        let key = "fNV2qOKKxARhR1Q7jD82jGZt"
        let location = "\(lat!),\(lon!)"
        if let data = Request.getRequestByFiltering("http://api.map.baidu.com/geocoder/v2/", requestTimeOut: 10, tag: 0, parameters: ("mcode","com.jxustnc.newxyt"),("ak",key),("location",location),("output","json")){
            do{
                let jsonresult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments) as! NSDictionary
                city = ((jsonresult["result"] as! NSDictionary)["addressComponent"] as! NSDictionary)["city"] as? String
            }catch{
                
            }
        }
        if let result = city{
            return result
        }else{
            return "无法查询城市名"
        }
    }
    
    func setShadow(isTap:Bool,views:UIImageView...){
        for view in views{
            view.layer.shadowOpacity = 0.8
            view.layer.shadowColor = UIColor.blackColor().CGColor
            view.layer.shadowOffset = isTap ? CGSize(width: -1, height: -1) : CGSize(width: 1, height: 1)
            view.layer.shadowRadius = 2
        }
    }
    
    
    func setZeroFrame(){
        scheduleView.frame.size = CGSizeZero
        scoreView.frame.size = CGSizeZero
        cetView.frame.size = CGSizeZero
        weatherView.frame.size = CGSizeZero
        scheduleView.clipsToBounds = true
        scoreView.clipsToBounds = true
        cetView.clipsToBounds = true
        weatherView.clipsToBounds = true
        self.scheduleView.frame.origin = CGPointMake(screen.width/2, screen.height/2)
        self.scoreView.frame.origin = CGPointMake(screen.width/2, screen.height/2)
        self.cetView.frame.origin = CGPointMake(screen.width/2, screen.height/2)
        self.weatherView.frame.origin = CGPointMake(screen.width/2, screen.height/2)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animateWithDuration(0.2) {
            self.scheduleView.frame.size = CGSizeMake(screen.width/2-30, screen.width/2-30)
            self.scoreView.frame.size = CGSizeMake(screen.width/2-30, screen.width/2-30)
            self.cetView.frame.size = CGSizeMake(screen.width/2-30, screen.width/2-30)
            self.weatherView.frame.size = CGSizeMake(screen.width/2-30, screen.width/2-30)
            self.scheduleView.frame.origin = CGPointMake(15, screen.height/2-screen.width/2)
            self.scoreView.frame.origin = CGPointMake(screen.width/2+15, screen.height/2-screen.width/2)
            self.cetView.frame.origin = CGPointMake(15, screen.height/2)
            self.weatherView.frame.origin = CGPointMake(screen.width/2+15, screen.height/2)
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        setZeroFrame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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


