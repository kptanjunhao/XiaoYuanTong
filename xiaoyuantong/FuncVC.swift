//
//  AssignVC.swift
//  SchoolBangBang
//
//  Created by 谭钧豪 on 16/5/14.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class FuncVC: MainVC {
    
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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
