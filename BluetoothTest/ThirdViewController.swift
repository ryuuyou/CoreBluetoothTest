//
//  ThirdViewController.swift
//  BluetoothTest
//
//  Created by 劉 陽 on 15/9/30.
//  Copyright © 2015年 yang liu. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class ThirdViewController:UIViewController, UITableViewDelegate, UITableViewDataSource, CBPeripheralDelegate,  UITextFieldDelegate {
    
    var myTableView: UITableView!
    var myCharacteristicsUuids: NSMutableArray = NSMutableArray()
    var myCharacteristics: NSMutableArray = NSMutableArray()
    var myWriteButton: UIButton!
    var myReadButton: UIButton!
    var myInvokeButton: UIButton!
    var myTargetPeriperal: CBPeripheral!
    var myService: CBService!
    var myTextField: UITextField!
    var myTargetCharacteristics: CBCharacteristic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blueColor()
        let barHeight: CGFloat = UIApplication.sharedApplication().statusBarFrame.size.height
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height

        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight/2 - barHeight))

        myTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "MyCell")

        myTableView.dataSource = self

        myTableView.delegate = self

        self.view.addSubview(myTableView)

        myTextField = UITextField(frame: CGRectMake(25,displayHeight/2 + 10,displayWidth-50,30))
        myTextField.delegate = self
        myTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.view.addSubview(myTextField)

        myReadButton = UIButton()
        myReadButton.frame = CGRectMake(displayWidth/2 + 60 - 100/2,displayHeight/2 + 100,100,40)
        myReadButton.backgroundColor = UIColor.redColor()
        myReadButton.layer.masksToBounds = true
        myReadButton.setTitle("Read", forState: UIControlState.Normal)
        myReadButton.layer.cornerRadius = 20.0
        myReadButton.tag = 1
        myReadButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myReadButton)

        myWriteButton = UIButton()
        myWriteButton.frame = CGRectMake(displayWidth/2 - 60 - 100/2,displayHeight/2 + 100,100,40)
        myWriteButton.backgroundColor = UIColor.greenColor()
        myWriteButton.layer.masksToBounds = true
        myWriteButton.setTitle("Write", forState: UIControlState.Normal)
        myWriteButton.layer.cornerRadius = 20.0
        myWriteButton.tag = 2
        myWriteButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myWriteButton)

        myInvokeButton = UIButton()
        myInvokeButton.frame = CGRectMake(displayWidth/2 - 200/2,displayHeight - 100,200,40)
        myInvokeButton.backgroundColor = UIColor.blackColor()
        myInvokeButton.layer.masksToBounds = true
        myInvokeButton.setTitle("Invoke App", forState: UIControlState.Normal)
        myInvokeButton.layer.cornerRadius = 20.0
        myInvokeButton.tag = 3
        myInvokeButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myInvokeButton)
    }
    
    func setPeripheral(target: CBPeripheral) {
        
        self.myTargetPeriperal = target
        
        print(target)
        
    }
    
    /*
    CentralManagerを設定
    */
    func setService(service: CBService) {
        
        self.myService = service
        print(service)
    }
    
    /*
    Charactaristicsの検索
    */
    func searchCharacteristics(){
        
        print("searchService")
        self.myTargetPeriperal.delegate = self
        self.myTargetPeriperal.discoverCharacteristics(nil, forService: self.myService)
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService,
        error: NSError?) {
            print("didDiscoverCharacteristicsForService")
            
            for characteristics in service.characteristics! {
                myCharacteristicsUuids.addObject(characteristics.UUID)
                myCharacteristics.addObject(characteristics)
            }
            
            myTableView.reloadData()
    }
    
    /*
    Cellが選択された際に呼び出される.
    */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("CharactaristicsUuid: \(myCharacteristicsUuids[indexPath.row])")
        myTargetCharacteristics = myCharacteristics[indexPath.row] as! CBCharacteristic
    }
    
    /*
    Cellの総数を返す.
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myCharacteristicsUuids.count
        
    }
    
    /*
    Cellに値を設定する.
    */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier:"MyCell" )
        
        // Cellに値を設定.
        cell.textLabel!.sizeToFit()
        cell.textLabel!.textColor = UIColor.redColor()
        cell.textLabel!.text = "\(myCharacteristicsUuids[indexPath.row])"
        cell.textLabel!.font = UIFont.systemFontOfSize(16)
        // Cellに値を設定(下).
        cell.detailTextLabel!.text = "Characteristics"
        cell.detailTextLabel!.font = UIFont.systemFontOfSize(12)
        
        return cell
        
    }
    
    
    /*
    ボタンイベント.
    */
    func onClickMyButton(sender: UIButton){
        print("onClickMyButton:")
        print("sender.currentTitile: \(sender.currentTitle)")
        print("sender.tag:\(sender.tag)")
        
        if(self.myTargetCharacteristics != nil){
            if(sender.tag == 1){
                self.myTargetPeriperal.readValueForCharacteristic(myTargetCharacteristics)
            }
            else if(sender.tag == 2){
                print("write")
                let data: NSData! = myTextField.text!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacteristics, type: CBCharacteristicWriteType.WithResponse)
            }
        }
        
        if(sender.tag == 3){
            // 遷移するViewを定義する.
            let myAppViewController: AppViewController = AppViewController()
            myAppViewController.setPeripheral(self.myTargetPeriperal)
            myAppViewController.setCharactaristics(self.myCharacteristics)
            
            // アニメーションを設定する.
            myAppViewController.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            
            print(self.navigationController)
            // Viewの移動する.
            self.navigationController?.pushViewController(myAppViewController, animated: true)
        }
    }
    
    /*
    read
    */
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    {
        var out: NSInteger = 0
        
        characteristic.value!.getBytes(&out, length: sizeof(NSInteger))
        print(UnicodeScalar(out))
        myTextField.text = String(UnicodeScalar(out))
    }
    
    
    /*
    Write
    */
    func peripheral(peripheral: CBPeripheral, didWriteValueForCharacteristic characteristic: CBCharacteristic, error: NSError?)
    {
        print("Success")
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForDescriptor descriptor: CBDescriptor, error: NSError?) {
        print("Success")
        
    }

    func textFieldDidBeginEditing(textField: UITextField){
        print("textFieldDidBeginEditing:" + textField.text!)
    }

    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("textFieldShouldEndEditing:" + textField.text!)
        
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}