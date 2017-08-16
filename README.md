# TTLock.framework

Development Tool: Xcode8.3.3 and above

Installation
First, add the following line to your Podfile:
pod 'TTLock'
If you want to use the latest features of TTLock use normal external source dependencies.
pod 'TTLock', :git => 'https://github.com/ttlock/iOS_TTLock_Demo.git'
This pulls from the master branch directly.
Second, install TTLock into your project:
pod install
Manually
1.Drag the TTLock.framework and DFUDependence.framework into your project.
2.Find the target settings in this application, then find 'General' -> 'Embedded Binaries', add  two frameworks above,such as

3.Add the CoreBluetooth framework to your project (Targets->Build Phases -> Link Binary With Libraries).


