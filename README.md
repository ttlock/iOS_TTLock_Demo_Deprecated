# TTLock.framework

Development Tool: Xcode8.3.3 and above

Installation

First, add the following line to your Podfile:

pod 'TTLock'

Second, install TTLock into your project:

pod install

Manually

1.Drag the TTLock.framework and DFUDependence.framework into your project.

2.Find the target settings in this application, then find 'General' -> 'Embedded Binaries', add the two frameworks above.
![image](https://github.com/ttlock/iOS_TTLock_Demo/blob/master/TTLockDemo/images/DesEmbedded.png)

3.Add the CoreBluetooth framework to your project (Targets->Build Phases -> Link Binary With Libraries).


