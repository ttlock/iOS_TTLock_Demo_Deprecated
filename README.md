# TTLock.framework


## Minimum iOS Target:
iOS 9.0


## Minimum Xcode Version: 
Xcode 10.2 


## Installation

### By Cocoapods

First, add the following line to your Podfile:
<br>use_frameworks!
<br>target 'YourAppTargetName' do
<br>pod 'TTLock'
<br>end

Second, install TTLock into your project:

pod install


### If you need to upgrade devices into your application,you should in addition to add TTLockDFU.framework and DFUDependence.framework

By Cocoapods
<br>First, add the following line to your Podfile:
<br>use_frameworks!
<br>target 'YourAppTargetName' do
<br>pod 'TTLockDFU' 
<br>end


## Introduction

### TTLock
TTLock has been designed to communicate with devices by mobile phone bluetooth.
TTLockGateway has been designed to make it easy to  communicate with  Wi-Fi module.

### TTLockDFU (Device Firmware Upgrade)
TTLockDFU has been designed to make it easy to upgrade devices into your application by mobile phone bluetooth.



## Usage

### TTLock Usage

1.Import header file :
```objective-c
#import <TTLock/TTLock.h>
```
2.The delegate of a TTLock object must adopt the TTSDKDelegate protocol. Create a singleton object for TTLock
```objective-c
<TTSDKDelegate>
TTLock *TTObject = [[TTLock alloc]initWithDelegate:self];   
```

3. Start bluetooth

```objective-c
[TTObject setupBlueTooth];  
```

4. Do you want to open the SDK log? YES print, NO does not print, and defaults to No
```objective-c
[TTLock setDebug:YES]; 
``` 

5.Executing the following code in the callback {@link TTManagerDidUpdateState:} what is Bluetooth state changing:
```objective-c 
if (state == TTManagerStatePoweredOn) {
[_TTObject startBTDeviceScan:YES];
}else if (state == TTManagerStatePoweredOff){
[_TTObject stopBTDeviceScan];
}else if (state == TTManagerStateUnsupported){
NSLog(@"Your device does not support ble4.0, unable to use our app.");   
}
```
6.It will execute the delegate method {@link onFoundDevice_peripheralWithInfoDic:} after scanning the device, you can get the basic information about the peripherals, such as, Bluetooth name, MAC address, isAllowUnlock, isContainAdmin and so on.

7.Connect lock by lockMac

```objective-c 
[TTObject connectPeripheralWithLockMac:(NSString *)lockMac];
```
6.It will execute the delegate method {@link onBTConnectSuccess_peripheral:lockName:} after connecting successfully.

In this method,firstly,you should Executing the following code :

```objective-c
[TTObject stopBTDeviceScan];
```

secondly,you should Executing the following code:  

```objective-c
TTObject.uid = openid;//In order to record who operates the lock
```
lastly, you can call interface such as, add administrator, open the door, etc…

7.It can receive corresponding callback after call appropriate interface, successful callback for success, error callback {@link TTError:command:errorMsg:} for failure.

8.Executing the following code in the callback {@link onBTDisconnect_peripheral:}:
```objective-c
[TTObject startBTDeviceScan];
```

### Scene: Add administrator
1.Scan devices nearby

2.Connect the lock which you want to add administrator(You can add administrator only if there is no administrator in this lock, and you can judge it by parameter ‘isContainAdmin’)
```objective-c
[TTObject connect:peripheral];(This parameter 'peripheral' is in the callback 'onFoundDevice_peripheralWithInfoDic')
```
3.After the connection is successful, you can call bluetooth interface {@link addAdministrator_addDic:}.

4.Use the network interface(v3/lock/init) to upload data after receiving the callback {@link onAddAdministrator_addAdminInfoDic:}. 

### Scene: Delete the lock

The three generation lock administrators delete the lock

1、Connect the lock you want to delete, then call Bluetooth interface {@link resetLock_adminPS:lockKey:aesKey:version: unlockFlag:}.

2、Call the network interface 'v3/key/delete' after receiving the callback {@link onResetLock}.

In addition to the three generation lock administrators 

1、Call the network interface 'v3/key/delete' directly.

### Scene: Unlock

1.Administrator calls bluetooth interface {@link unlockByAdministrator_adminPS:lockKey:aesKey:version:unlockFlag:unlockFlag:uniqueid:timezoneRawOffset:} ,Ekey calls bluetooth interface {@unlockByUser_lockKey:aesKey:startDate:endDate:version:unlockFlag:uniqueid:timezoneRawOffset:} after connecting the lock which you want to open.

2.Call Bluetooth interface {@link setLockTime_lockKey:aesKey:version:unlockFlag:referenceTime:timezoneRawOffset:} after receiving the Successful callback {@onUnlockWithLockTime:}. 

3.Receive successful callback {@link onSetLockTime}.

## Notes

### TTLock Notes

1.If you need to call many bluetooth interfaces at the same time ,you must call the following interface after the previous interface callback.

Such as,you want to unlock ,and  calibrate time.  

#### Wrong demonstration

-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName{
<br>  // unlock
<br> [TTObject unlockByUser_lockKey:lockKey aesKey:aesKeyStr startDate:startDate endDate:endDate version:version unlockFlag:unlockFlag uniqueid:uniqueid timezoneRawOffset:timezoneRawOffset];
<br> //calibrate time
<br>[TTObject setLockTime_lockKey:lockKey aesKey:aesKeyStr version:version unlockFlag:unlockFlag referenceTime:referenceTime timezoneRawOffset:timezoneRawOffset];

}

#### Correct demonstration
```objective-c   
-(void)onBTConnectSuccess_peripheral:(CBPeripheral *)peripheral lockName:(NSString*)lockName{

// unlock
[TTObject unlockByUser_lockKey:lockKey aesKey:aesKeyStr startDate:startDate endDate:endDate version:version unlockFlag:unlockFlag uniqueid:uniqueid timezoneRawOffset:timezoneRawOffset];

}

//after receiving the callback of unlock successfully
-(void)onUnlockWithLockTime:(NSTimeInterval)lockTime{

//calibrate time
[TTObject setLockTime_lockKey:lockKey aesKey:aesKeyStr version:version unlockFlag:unlockFlag referenceTime:referenceTime timezoneRawOffset:timezoneRawOffset];

}
```

<br>2.The callback {@link onFoundDevice_peripheralWithInfoDic:} will scan all supported devices nearby, just connect which you really need.
  
<br>3.All callbacks in the TTLock are in the child thread.
  
<br>4.In order to record who operates the lock,you should assign values to attributes 'uid' before sending instruction in the callback {@link onBTConnectSuccess_peripheral:lockName:}. 
```objective-c  
  TTObject.uid = openid; 
```
<br>5.{@link connectPeripheralWithLockMac:}Connection attempts never time out .Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via {@link cancelConnectPeripheralWithLockMac:}. {@link connect:}Connection attempts never time out .Pending attempts are cancelled automatically upon deallocation of <i>peripheral</i>, and explicitly via {@link disconnect:}.
