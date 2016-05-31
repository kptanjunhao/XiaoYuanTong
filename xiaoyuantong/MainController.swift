//
//  MainVC.swift
//  Demo
//
//  Created by 谭钧豪 on 16/5/11.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

func imageWithIcon(iconCode:String,fontName:String,size:CGFloat,color:UIColor...) -> UIImage {
    let imageSize = CGSizeMake(size, size)
    UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.mainScreen().scale)
    let label = UILabel(frame: CGRectMake(0,0,size,size))
    label.font = UIFont(name: fontName, size: size)
    label.text = iconCode
    if color.count != 0{
        label.textColor = color[0]
    }
    label.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    return UIGraphicsGetImageFromCurrentImageContext()
    
}

class MainTBC: UITabBarController,UITabBarControllerDelegate {
    
    init(viewControllers:UIViewController...){
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers
        self.tabBar.tintColor = Config.mainColor
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.tabBar.translucent = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        let animation = CATransition()
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.type = kCATransitionMoveIn
        animation.subtype = kCATransitionFade
        tabBarController.view.layer.addAnimation(animation, forKey: "animation")
        return true
    }
    
    
}

class MainNC: UINavigationController {

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.translucent = false
        self.navigationBar.barTintColor = Config.mainColor
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}



class MainVC: UIViewController {
    
    
    var menuView: MenuView?
    
    init(nibName: String?,bg:UIColor){
        super.init(nibName: nibName, bundle: nil)
        self.view.backgroundColor = bg
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showMenu(){
        self.showMenuIfHidden(nil)
    }
    
    func showMenuIfHidden(hidden:Bool?){
        if menuView == nil{
            return
        }
        var menuStatu = Bool()
        if let _ = hidden{
            menuStatu = !hidden!
        }else{
            menuStatu = !self.menuView!.isOpen
        }
        
        self.menuView!.animateMenu(0.2, isToOpen: menuStatu)

    }
    
    func addMenuView(items:MenuButton...){
        if items.count == 0{
            return
        }
        self.menuView = MenuView(frame: CGRectMake(screen.width - 155,5,150,40), items: items)
        self.view.addSubview(menuView!)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        showMenuIfHidden(true)
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
