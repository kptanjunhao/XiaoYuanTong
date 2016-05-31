//
//  ViewController.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/5/27.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer: NSTimer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(1200, target: self, selector: #selector(self.uploadCheck), userInfo: nil, repeats: true)
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,3000000000), LOG_QUEUE) {
//            self.timer.fire()
//        }
        let FuncVCWithNav = MainNC(rootViewController: FuncVC())
        let MainVCWithNav = MainNC(rootViewController: ContactVC())
        let tabbarC = MainTBC(viewControllers: FuncVCWithNav,MainVCWithNav)
        self.presentViewController(tabbarC , animated: true, completion: nil)
    }
    
    func uploadCheck(){
        dispatch_async(LOG_QUEUE) {
            Log.uploadCheck()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

