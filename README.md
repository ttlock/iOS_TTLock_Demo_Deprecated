# TTLock.framework

## Minimum iOS Target: iOS 8.0

## Minimum Xcode Version: Xcode 8.3.3

## Installation

First, add the following line to your Podfile:

pod 'TTLock'

Second, install TTLock into your project:

pod install

### Manually

1.Drag the TTLock.framework and DFUDependence.framework into your project.

2.Find the target settings in this application, then find 'General' -> 'Embedded Binaries', add the two frameworks above.

3.Add the CoreBluetooth framework to your project (Targets->Build Phases -> Link Binary With Libraries).

## Introduction

### TTLockLock
TTLockLock has been designed to communicate with devices by mobile phone bluetooth.

### TTLockGateway
TTLockGateway has been designed to make it easy to  communicate with  Wi-Fi module.

### TTLockDFU (Device Firmware Upgrade)
TTLockDFU has been designed to make it easy to upgrade devices into your application by mobile phone bluetooth.

## Usage

### TTLockLock Usage

1.Import header file :
```objective-c
 #import <TTLock/TTLock.h>
```
2.Create a singleton object for TTLock
```objective-c
    TTLock *TTObject = [[TTLock alloc]initWithDelegate:self];   
```
  Create a Bluetooth central object and starts Bluetooth
```objective-c  
    [TTObject setupBlueTooth];  
```    
  Do you want to open the SDK log? YES print, NO does not print, and defaults to No
  ```objective-c
    [TTLock setDebug:YES]; 
 ```   
3.Executing the following code in the callback of TTLockManagerDidUpdateState what is Bluetooth state changing:
```objective-c
    if (central.state == CBCentralManagerStatePoweredOn) {
        [TTObject startBTDeviceScan]; //start scanning
    }else if (central.state == CBCentralManagerStatePoweredOff){ 
        [TTObject stopBTDeviceScan];  // stop scanning
    }else if(central.state == CBCentralManagerStateUnsupported){    
        NSLog(@"Your device does not support ble4.0, unable to use our app.");   
    }
```
4.It will execute the delegate method of ‘onFoundDevice_peripheral’ after scanning the device, you can get the basic information about the peripherals, such as, Bluetooth name, MAC address, broadcast data and so on.

5.You can connect the given Bluetooth by the way of scanning peripheral above.
```objective-c
   [TTObject connect:peripheral];
```
6.It will execute the delegate method of ‘onBTConnectSuccess_peripheral’ after connecting successfully.
  
  In this method,firstly,you should Executing the following code :
 ```objective-c 
  [TTObject stopBTDeviceScan];
 ``` 
  secondly,you should Executing the following code:
```objective-c  
  TTObject.uid = openid;
```  
  lastly, you can send instructions such as, add administrator, open the door, etc…

7.Lock will return corresponding callback after receiving the appropriate instruction, successful callback for success, error callback for  failure.

8.Executing the following code in the callback of onBTDisconnect_peripheral:
```objective-c
   [TTObject startBTDeviceScan];
```

### Scene: Add administrator
1.Scan devices nearby

2.Connect the lock which you want to add administrator(You can add administrator only if there is no administrator in this lock, and you can judge it by parameter ‘isContainAdmin’)
```objective-c
  [TTObject connect:peripheral];(This parameter 'peripheral' is in the callback 'onFoundDevice_peripheralWithInfoDic')
```
3.After the connection is successful, you can call Bluetooth interface ‘addAdministrator’.

4.Use the network interface(v3/lock/init) to upload data after receiving the callback of 'onAddAdministrator'. 

### Scene: Delete the lock

The three generation lock administrators delete the lock

1、Connect the lock you want to delete, then call Bluetooth interface ‘resetLock’.

2、Call the network interface 'v3/key/delete' after receiving the callback 'onResetLock'.

In addition to the three generation lock administrators 

1、Call the network interface 'v3/key/delete' directly.

### Scene: Open the door

1.Administrator calls bluetooth interface ‘unlockByAdministrator’ ,Ekey calls bluetooth interface ‘unlockByUser’ after connecting the lock which you want to open.

2.Call Bluetooth interface 'setLockTime' after receiving the callback of ‘onUnlockWithLockTime’. 

3.Receive the callback(‘onSetLockTime’) of successful calibrate the time.


## Notes

### TTLockLock Notes

1.The callback for ‘onFoundDevice_peripheral’ will scan all devices nearby which broadcast ‘1910’ service, just connect which you really need.

2.If you need to send many instructions at the same time ,you must send the following instruction  after the previous instruction callback.

3.All callbacks in the TTLockLock are in the child thread.

4.In order to record who operates the lock,you should assign values to attributes 'uid' before Sending instruction in the callback 'onBTConnectSuccess_peripheral'. 
```objective-c  
  TTObject.uid = openid; 
 ```




