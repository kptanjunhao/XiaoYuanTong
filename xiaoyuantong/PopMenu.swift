//
//  PopMenu.swift
//  SchoolBangBang
//
//  Created by 谭钧豪 on 16/5/14.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class MenuButton: UIButton {
    
    init(target:AnyObject?,title:String,selector:Selector){
        super.init(frame: CGRectZero)
        self.setTitle(title, forState: UIControlState.Normal)
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.addTarget(self, action: #selector(self.touchUpInside), forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: #selector(self.clearBtn), forControlEvents: UIControlEvents.TouchDragExit)
        self.addTarget(self, action: #selector(self.touchDown), forControlEvents: UIControlEvents.TouchDown)
        self.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).CGColor
        self.layer.borderWidth = 0.5
        
        self.addTarget(target, action: selector, forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func touchUpInside(){
        (superview as? MenuView)?.animateMenu(0.2, isToOpen: false)
        self.clearBtn()
    }
    
    func clearBtn(){
        UIView.animateWithDuration(0.1) { 
            self.backgroundColor = UIColor.clearColor()
        }
    }
    
    func touchDown(){
        UIView.animateWithDuration(0.1) {
            self.backgroundColor = UIColor(red: 0.9375, green: 0.9375, blue: 0.9375, alpha: 1)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class MenuView: UIView {
    
    enum MenuViewError: ErrorType {
        case canNotDeleteItemByIndexOutOfRange
        case noSuchItemInMenuView
    }
    
    
    var numberOfItem = 0
    var itemHeight: CGFloat = 0
    var menuZeroFrame: CGRect!
    var menuFullFrame: CGRect!
    var isOpen = false
    var items:[MenuButton]!
    var mask: UIView!
    
    
    /**
     frame的height填单个item的高度
     */
    init(frame: CGRect, items:[MenuButton]) {
        self.items = items
        self.numberOfItem = items.count
        self.menuZeroFrame = CGRectMake(frame.origin.x + frame.width, frame.origin.y, 0, 0)
        self.menuFullFrame = frame
        itemHeight = frame.height
        menuFullFrame.size.height = CGFloat(numberOfItem)*itemHeight
        super.init(frame: menuZeroFrame)
        mask = UIView(frame: screen)
        mask.hidden = true
        mask.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.close)))
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        for itemIndex in 0..<items.count {
            self.addSubview(items[itemIndex])
        }
    }
    
    /**
     - parameters:
     - item: MenuButton类型，要添加的菜单对象。
     - indexOfItem: 要插入的位置，若nil则默认是首位插入，若给出的index超出菜单数量，则默认末位插入
     */
    func addItem(item:MenuButton,indexOfItem:Int?){
        if let indexOfItem = indexOfItem{
            if indexOfItem > items.count{
                items.insert(item, atIndex: items.count)
            }else{
                items.insert(item, atIndex: indexOfItem)
            }
        }else{
            items.insert(item, atIndex: 0)
        }
        numberOfItem = items.count
        menuFullFrame.size.height = CGFloat(numberOfItem)*itemHeight
        reSortItems()
    }
    /**
     - parameters:
        - item: MenuButton类型，要删除的菜单对象。
     - returns:
        - Int   返回剩余菜单的数量
     - throws:
        - canNotDeleteItemByIndexOutOfRange 剩余菜单数量为0无法删除
        - noSuchItemInMenuView 菜单中没有这个对象
     */
    func deleteItem(item:MenuButton) throws -> Int {
        if let indexWillRemove = items.indexOf(item){
            if numberOfItem < 1{
                throw MenuViewError.canNotDeleteItemByIndexOutOfRange
            }
            items.removeAtIndex(indexWillRemove)
            numberOfItem = items.count
            menuFullFrame.size.height = CGFloat(numberOfItem)*itemHeight
        }else{
            throw MenuViewError.noSuchItemInMenuView
        }
        reSortItems()
        return items.count
    }
    
    func reSortItems(){
        for item in self.subviews{
            item.removeFromSuperview()
        }
        for item in items{
            self.addSubview(item)
        }
    }
    
    func close(){
        self.mask.userInteractionEnabled = false
        self.animateMenu(0.2, isToOpen: false)
    }
    
    func animateMenu(duration: NSTimeInterval,isToOpen:Bool){
        if self.isOpen == isToOpen{
            return
        }
        self.mask.hidden = false
        animateSubButton(duration,isToOpen: isToOpen)
        UIView.animateWithDuration(duration, animations: {
            self.mask.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: !isToOpen ? 0 : 0.0625)
            self.frame = isToOpen ? self.menuFullFrame : self.menuZeroFrame
        }) { (_) in
            self.mask.userInteractionEnabled = true
            self.mask.hidden = !isToOpen
            self.isOpen = isToOpen
        }
    }
    
    func animateSubButton(duration: NSTimeInterval,isToOpen:Bool){
        UIView.animateWithDuration(duration) {
            for itemIndex in 0..<self.items.count {
                self.items[itemIndex].frame = isToOpen ? CGRectMake(0, CGFloat(itemIndex)*self.itemHeight, self.menuFullFrame.width, self.itemHeight) : CGRectZero
            }
        }
    }
    
    
    
    override func didMoveToSuperview() {
        self.setNeedsDisplay()
        self.superview!.addSubview(mask)
        self.superview!.bringSubviewToFront(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}