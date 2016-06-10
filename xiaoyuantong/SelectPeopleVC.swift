//
//  SelectPeopleVC.swift
//  xiaoyuantong
//
//  Created by 谭钧豪 on 16/6/2.
//  Copyright © 2016年 谭钧豪. All rights reserved.
//

import UIKit

class SelectPeopleVC: UITableViewController {
    var groupList:GroupList!
    var vc:CreateNoticeVC!
    
    init(groupList:GroupList,vc:CreateNoticeVC){
        self.groupList = groupList
        self.vc = vc
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let recvPeopleCellNib = UINib(nibName: "RecvPeopleCell", bundle: nil)
        self.tableView.registerNib(recvPeopleCellNib, forCellReuseIdentifier: "RecvPeopleCell")
        self.tableView.registerClass(SelectHeaderView.self, forHeaderFooterViewReuseIdentifier: "SelectHeaderView")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return groupList.groups.count
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func sectionTap(sender:UITapGestureRecognizer){
        let senderView = sender.view as! HeaderView
        let section = senderView.section
        self.tableView.beginUpdates()
        groupList!.groups[section].isClose = !groupList!.groups[section].isClose
        senderView.touch(groupList!.groups[section].isClose)
        let countOfRow = groupList!.groups[section].friends!.count
        var indexPaths = [NSIndexPath]()
        for i in 0..<countOfRow{
            indexPaths.append(NSIndexPath(forRow: i, inSection: section))
        }
        if groupList!.groups[section].isClose{
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        }else{
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        }
        self.tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("SelectHeaderView") as! SelectHeaderView
        let group = groupList!.groups[section]
        let groupName = group.groupName + " \((group.friends!).count)位"
        headerView.setUp(groupName, section: section, height: 44,isClose: group.isClose, group: group,vc: self.vc, tableView: tableView)
        headerView.addGesture(UITapGestureRecognizer(target: self, action: #selector(self.sectionTap(_:))))
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! RecvPeopleCell
        cell.selectPeople()
        let section = tableView.headerViewForSection(indexPath.section) as! SelectHeaderView
        section.cancelSelected()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let isClose = groupList?.groups[section].isClose{
            if isClose{
                return 0
            }else{
                return groupList?.groups[section].friends?.count ?? 0
            }
        }else{
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecvPeopleCell") as! RecvPeopleCell
        let contact = groupList.groups[indexPath.section].friends![indexPath.row]
        cell.setUp(contact, vc: self.vc)
        return cell
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
