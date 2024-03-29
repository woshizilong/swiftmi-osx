//
//  PopoverViewController.swift
//  swiftmi
//
//  Created by yangyin on 16/5/16.
//  Copyright © 2016年 swiftmi. All rights reserved.
//

import Cocoa
import SwiftyTimer
import SwiftDate

class PopoverViewController: NSViewController {

     
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var lastUpdated: NSTextField!
    var articles: [Article] = [Article]()
    var articleServices = ArticleServices()

    private var reloadDataTimer: NSTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.tableView.setDataSource(self)
        self.tableView.setDelegate(self)

        loadData();
    }
    
    override func viewWillAppear() {
        //self.tableView.reloadData()
        super.viewWillAppear()
        reloadDataTimer = NSTimer.every(15.seconds) {
            [weak self] in
            self?.loadData();
        }
    }
    
    @IBAction func toggleSettingButton(sender: NSView) {
        SMSettingsMenuAction.perform(sender)
        
    }
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        if let timer = reloadDataTimer {
            timer.invalidate()
        }
        
        reloadDataTimer = nil
    }
    
    func updateLastLabel() {
        
        let currentDate = NSDate()
        let time = currentDate.toString(DateFormat.Custom("YYYY-MM-dd HH:mm:ss"))
        lastUpdated.stringValue = "更新时间 \(time!)"
    }
    
    func loadData() {
        articleServices.loadData(0) {
            articles in
            if let items = articles {
                self.articles = items
                self.tableView.reloadData()
                self.updateLastLabel()
            }
            
        }
    }
    
    
    
}

// MARK: - NSTableViewDataSource
extension PopoverViewController: NSTableViewDataSource {
    func numberOfRowsInTableView(aTableView: NSTableView) -> Int {
        print(self.articles)
        return self.articles.count
    }
    
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cellView = tableView.makeViewWithIdentifier(tableColumn!.identifier, owner: tableView) as! TBCell
        cellView.configureData(self.articles[row])
        return cellView
    }
    
}

extension PopoverViewController: NSTableViewDelegate {
    func tableViewSelectionDidChange(notification: NSNotification) {
        let table = notification.object as! NSTableView
         NSWorkspace.sharedWorkspace().openURL(NSURL(string: self.articles[table.selectedRow].url)!)
    }
    
}

