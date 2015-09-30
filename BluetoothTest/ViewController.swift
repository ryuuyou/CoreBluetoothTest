//
//  ViewController.swift
//  BluetoothTest
//
//  Created by 劉 陽 on 15/9/30.
//  Copyright © 2015年 yang liu. All rights reserved.
//


import UIKit
import CoreBluetooth

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate {

    var myTableView: UITableView!
    var myUuids: NSMutableArray = NSMutableArray()
    var myNames: NSMutableArray = NSMutableArray()
    var myPeripheral: NSMutableArray = NSMutableArray()
    var myCentralManager: CBCentralManager!
    var myTargetPeripheral: CBPeripheral!
    let myButton: UIButton = UIButton()
    let dataSets = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        self.view.addSubview(myTableView)
        
        
        myButton.frame = CGRectMake(0,0,200,40)
        myButton.backgroundColor = UIColor.redColor();
        myButton.layer.masksToBounds = true
        myButton.setTitle("検索", forState: UIControlState.Normal)
        myButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.frame.width/2, y:self.view.frame.height-50)
        myButton.tag = 1
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)

        self.view.addSubview(myButton);
    }
    
    func onClickMyButton(sender: UIButton){
        
        myNames = NSMutableArray()
        myUuids = NSMutableArray()
        myPeripheral = NSMutableArray()
        
        startCentralManager()
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func startCentralManager(){
        // CoreBluetoothを初期化および始動.
        self.myCentralManager = CBCentralManager(delegate: self, queue: nil)
    }
    func alertView(message:String){
        let alertController = UIAlertController(title: "title", message: message, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.Cancel, handler: nil)
//        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
        
        alertController.addAction(cancelAction)
//        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    func centralManagerDidUpdateState(central: CBCentralManager) {
        print("state:\(central.state)")
        
        switch (central.state) {
        //CBCentralManagerState省略しました
        case .PoweredOff:
            print("Bluetoothの電源がOff")
            alertView("Bluetoothの電源がOff")
        case .PoweredOn:
            print("Bluetoothの電源はOn")
            // BLEデバイスの検出を開始.
            myCentralManager.scanForPeripheralsWithServices(nil, options: nil)
        case .Resetting:
            print("レスティング状態")
            alertView("レスティング状態")
        case .Unauthorized:
            print("非認証状態")
            alertView("非認証状態")
        case .Unknown:
            print("不明")
            alertView("不明")
        case .Unsupported:
            print("非対応")
            alertView("非対応")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        print("pheripheral.name: \(peripheral.name)")
        print("advertisementData:\(advertisementData)")
        print("RSSI: \(RSSI)")
        print("peripheral.identifier.UUIDString: \(peripheral.identifier.UUIDString)")
        
        var name: NSString? = advertisementData["kCBAdvDataLocalName"] as? NSString
        if (name == nil) {
            name = "no name";
        }
        myNames.addObject(name!)
        
        myPeripheral.addObject(peripheral)
        myUuids.addObject(peripheral.identifier.UUIDString)
        
        myTableView.reloadData()
    }

    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("")
        let mySecondViewController: SecondViewController = SecondViewController()
        
        print("setPeripheral")
        mySecondViewController.setPeripheral(peripheral)
        mySecondViewController.setCentralManager(central)
        mySecondViewController.searchService()

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Num: \(indexPath.row)")
        print("Uuid: \(myUuids[indexPath.row])")
        print("Name: \(myNames[indexPath.row])")
        
        self.myTargetPeripheral = myPeripheral[indexPath.row] as! CBPeripheral
        myCentralManager.connectPeripheral(self.myTargetPeripheral, options: nil)
        
    }
    
    /*
    Cellの総数を返す.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myUuids.count
    }
    
    /*
    Cellに値を設定する.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"MyCell" )
        
        // Cellに値を設定.
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.redColor()
        cell.textLabel!.text = "\(myNames[indexPath.row])"
        cell.textLabel!.font = UIFont.systemFontOfSize(20)
        // Cellに値を設定(下).
        cell.detailTextLabel!.text = "\(myUuids[indexPath.row])"
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)
        return cell
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        print("接続できません")
    }
}

