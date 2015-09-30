//
//  AppViewController.swift
//  BluetoothTest
//
//  Created by 劉 陽 on 15/9/30.
//  Copyright © 2015年 yang liu. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class AppViewController: UIViewController, CBPeripheralDelegate{
    
    var myTableView: UITableView!
    var myCharacteristics: NSMutableArray = NSMutableArray()
    var myRightButton: UIButton!
    var myLeftButton: UIButton!
    var myUpButton: UIButton!
    var myDownButton: UIButton!
    var myStopButton: UIButton!
    var myInvokeButton: UIButton!
    var myTargetPeriperal: CBPeripheral!
    var myService: CBService!
    var myTextField: UITextField!
    var myTargetCharacteristics: CBCharacteristic!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.yellowColor()
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        
        // Upボタン.
        myUpButton = UIButton()
        myUpButton.frame = CGRectMake(displayWidth/2 - 60/2,displayHeight/2 - 100 - 60/2,60,60)
        myUpButton.backgroundColor = UIColor.blackColor()
        myUpButton.layer.masksToBounds = true
        myUpButton.setTitle("↑", forState: UIControlState.Normal)
        myUpButton.layer.cornerRadius = 30.0
        myUpButton.tag = 1
        myUpButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myUpButton)
        
        // Downボタン.
        myDownButton = UIButton()
        myDownButton.frame = CGRectMake(displayWidth/2 - 60/2,displayHeight/2 + 100 - 60/2,60,60)
        myDownButton.backgroundColor = UIColor.blackColor()
        myDownButton.layer.masksToBounds = true
        myDownButton.setTitle("↓", forState: UIControlState.Normal)
        myDownButton.layer.cornerRadius = 30.0
        myDownButton.tag = 2
        myDownButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myDownButton)
        
        // Rightボタン.
        myRightButton = UIButton()
        myRightButton.frame = CGRectMake(displayWidth/2 + 100 - 60/2,displayHeight/2 - 60/2,60,60)
        myRightButton.backgroundColor = UIColor.blackColor()
        myRightButton.layer.masksToBounds = true
        myRightButton.setTitle("→", forState: UIControlState.Normal)
        myRightButton.layer.cornerRadius = 30.0
        myRightButton.tag = 3
        myRightButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myRightButton)
        
        // Leftボタン.
        myLeftButton = UIButton()
        myLeftButton.frame = CGRectMake(displayWidth/2 - 100 - 60/2,displayHeight/2 - 60/2,60,60)
        myLeftButton.backgroundColor = UIColor.blackColor()
        myLeftButton.layer.masksToBounds = true
        myLeftButton.setTitle("←", forState: UIControlState.Normal)
        myLeftButton.layer.cornerRadius = 30.0
        myLeftButton.tag = 4
        myLeftButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myLeftButton)
        
        // Stopボタン.
        myStopButton = UIButton()
        myStopButton.frame = CGRectMake(displayWidth/2 - 60/2,displayHeight/2 - 60/2,60,60)
        myStopButton.backgroundColor = UIColor.blackColor()
        myStopButton.layer.masksToBounds = true
        myStopButton.setTitle("x", forState: UIControlState.Normal)
        myStopButton.layer.cornerRadius = 30.0
        myStopButton.tag = 5
        myStopButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        self.view.addSubview(myStopButton)
        
    }
    
    /*
    接続先のPeripheralを設定
    */
    func setPeripheral(target: CBPeripheral) {
        
        self.myTargetPeriperal = target
        
        print(target)
        
    }
    
    /*
    Characteristics(複数)を設定
    */
    func setCharactaristics(characteristics: NSMutableArray) {
        
        self.myCharacteristics = characteristics
        self.myTargetCharacteristics = characteristics[0] as! CBCharacteristic
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
                let data: NSData! = "1".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacteristics, type: CBCharacteristicWriteType.WithResponse)
            }
            else if(sender.tag == 2){
                let data: NSData! = "2".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacteristics, type: CBCharacteristicWriteType.WithResponse)
            }
            else if(sender.tag == 3){
                let data: NSData! = "3".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacteristics, type: CBCharacteristicWriteType.WithResponse)
            }
            else if(sender.tag == 4){
                let data: NSData! = "4".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacteristics, type: CBCharacteristicWriteType.WithResponse)
            }
            else if(sender.tag == 5){
                let data: NSData! = "5".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion:true)
                
                self.myTargetPeriperal.writeValue(data, forCharacteristic: myTargetCharacteristics, type: CBCharacteristicWriteType.WithResponse)
            }
            
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
    
}

