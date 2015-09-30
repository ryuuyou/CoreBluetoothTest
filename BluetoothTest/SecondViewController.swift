//
//  SecondViewController.swift
//  BluetoothTest
//
//  Created by 劉 陽 on 15/9/30.
//  Copyright © 2015年 yang liu. All rights reserved.
//

import UIKit
import Foundation
import CoreBluetooth

class SecondViewController:UIViewController,UITableViewDelegate,UITableViewDataSource,CBPeripheralDelegate {
    var myTableView: UITableView!
    var myServiceUuids: NSMutableArray = NSMutableArray()
    var myService: NSMutableArray = NSMutableArray()
    var myButtonBefore: UIButton!
    var myTargetPeriperal: CBPeripheral!
    var myCentralManager: CBCentralManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
    }
    
    func setPeripheral(targer:CBPeripheral){
        self.myTargetPeriperal = targer
        print(targer)
    }
    func setCentralManager(manager:CBCentralManager){
        self.myCentralManager = manager
        print(manager)
    }
    
    func searchService(){
        self.myTargetPeriperal.delegate = self
        self.myTargetPeriperal.discoverServices(nil)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        for service in peripheral.services!{
            myServiceUuids.addObject(service.UUID)
            myService.addObject(service)
            
            print("P:\(peripheral.name)  Discovered service S:\(service.UUID)")
            
            myTableView.reloadData()
        }
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("ServiceUuid: \(myServiceUuids[indexPath.row])")
        let myThirdViewController: ThirdViewController = ThirdViewController()
        myThirdViewController.setPeripheral(self.myTargetPeriperal)
        myThirdViewController.setService(self.myService[indexPath.row] as! CBService)
        myThirdViewController.searchCharacteristics()
        
        // アニメーションを設定する.
        myThirdViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        print(self.navigationController)
        // Viewの移動する.
        self.navigationController?.pushViewController(myThirdViewController, animated: true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myServiceUuids.count
        
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"MyCell" )
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.redColor()
        cell.textLabel!.text = "\(myServiceUuids[indexPath.row])"
        cell.textLabel!.font = UIFont.systemFontOfSize(16)
        cell.detailTextLabel!.text = "Service"
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)
        
        return cell
        
    }

    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil{
            self.myCentralManager.cancelPeripheralConnection(self.myTargetPeriperal)
            
        }
    }
}