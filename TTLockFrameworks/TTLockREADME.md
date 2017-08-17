# TTLock
SDK2.7
1.TTLock.h 改名 TTLockLock
2.静态库换成动态库，增加网关(TTLockGateway.h)和升级锁功能(TTLockDFU.h)

SDK2.6.5
1.增加错误码0x1D  
2.增加操作记录类型8

SDK2.6.4
1.增加读取有效密码、读取IC卡号、读取指纹密码、恢复密码、恢复IC卡、恢复指纹功能。
2.搜索回调里，参数scene的注解修改。
3.门锁校准时间时，身份验证失败，继续校准。


SDK2.6.3
1.增加修改键盘密码（modifyKeyboardPassword_newPassword）和修改键盘密码成功（onModifyUserKeyBoardPassword）两个接口。
2.增加添加键盘密码（addKeyboardPassword_password）和添加键盘密码成功（onAddUserKeyBoardPassword）两个接口。
3.蓝牙搜索到设备的回调中减少 groupId（应用商）和 orgId（公司）两个参数的返回。
4.枚举类型TTError修改:TTErrorICFail改成TTErrorFail，并且增加不支持修改密码(TTErrorNotSupportModifyPwd)类型
5.添加类TTSpecialValueUtil，用来判断特征值（是否支持密码、IC卡、指纹等）
6.新增接口关闭锁（locking_lockKey），适用车位锁以及支持此功能的门锁）,新增对应回调onLockingWithLockTime(开(闭、上)锁成功)，废弃原来的回调onLock，废弃属性parklockAction
7.新增接口查询锁开关状态(getLockSwitchState_aesKey)，新增对应回调onGetLockSwitchState
8.新增接口是否在屏幕上显示输入的密码（operateScreen_type），新增对应回调onQueryScreenState和onModifyScreenShowState
9.新增接口设置蓝牙名字（setLockName),新增对应回调onSetLockName


SDK2.6.2
1.bug修改，与锁通信时固定来源

SDK2.6.1
1.蓝牙搜索到设备的回调:onFoundDevice_peripheralWithInfoDic,返回的字典中增加键protocolVersion、scene、groupId、orgId；
2.增加操作记录类型25;



SDK2.6 
1.增加获取设备的信息 包括 1-产品型号 2-硬件版本号 3-固件版本号 4-生产日期 5-蓝牙地址 6-时钟
2.增加进入可固件升级状态的接口 upgradeFirmware
3.添加管理员成功返回接口修改，参数全部放在一个字典中返回
4.时钟校准，sdk2.6及以后版本不再自行校准（之前版本:添加添加完管理员或开门成功后，sdk里面会进行一次时间校准），如果开发者需要进行时钟校准，请调用接口setLockTime_lockKey进行校准！！！！！！！！！！
5.增加可搜索特定服务的蓝牙设备接口 scanSpecificServicesBluetoothDevice_ServicesArray
6.添加属性isShowBleAlert，设置系统检测蓝牙未打开的弹框是否显示，可不设置(默认是关闭 NO)
7.接口修改，跟时间有关的接口都增加参数timezoneRawOffset 跟开门有关的接口都增加uniqueid

SDK2.5 
1.添加闭锁功能
2.指纹相关操作记录格式错误问题
3.IC卡 指纹和手环相关接口加上标记位unlockFlag参数
4.注解较之前更全面

SDK2.4.2
1.解决 接口校准锁的时钟并开锁 calibationTimeAndUnlock_lockKey，lock锁无法开门的问题

SDK2.4.1
1.增加接口:开始扫描附近所有蓝牙设备 如果有开发手环的需要可以用 - (void)scanAllBluetoothDeviceNearby
  之前的 -(void)startBTDeviceScan 开始扫描附近具有特定服务的门锁  如果只开发门锁，推荐使用！！！！
2.修复上个版本中删除单个密码无法删除的bug
3.操作记录增加指纹类型

SDK2.4
1.解决 添加管理员的回调中 mac与锁名不符合的偶发情况
2.解决上个版本中Lock锁无法添加的问题    ！！！ 推荐使用

SDK2.3
1.添加指纹功能
2.修改了sdk中一些已发现不合理的地方

SDK2.2.1
1.解决4s下，IC无法正确读出卡号的问题

SDK2.2
1.添加了手环功能
2.修复上个版本中设置了setClientPara，添加管理员的bug

SDK2.1.1
1.蓝牙开始扫描和停止扫描都要主动调用 !!!!!!!!!!!!!! 
  注 (1)刚创建TTLock对象时不要立即调用startBTDeviceScan，因为蓝牙对象创建到可以使用需要一点点时间 1.可以隔一点点时间再调用  2.可以在TTLockManagerDidUpdateState代理方法里，当满足（central.state == CBCentralManagerStatePoweredOn）时调用
     (2)当蓝牙连接上时最好先停止扫描，防止数据错乱。
2.修复读取操作记录不正常中断的数据处理的问题
3.添加了属性setClientPara 三代门锁添加管理员时的固定数据 不传为默认字串
4.网络接口由v1改成v2      


SDK2.1
1.增加对三代锁IC卡的支持


SDK2.0.1
1. 调用的蓝牙接口中的管理员密码、约定数和aeskey的数据类型由NSData改成NSString!!!!!!!!(方便上传和请求）
2. 原管理员密码 password 改为adminPS  原约定数 key 改为lockkey


SDK2.0
1. 调用的接口名称全部更新（如果之前使用过sdk,请对照 TTLockDemo中  表iOS  SDK接口列表）
2. 重置(生成)键盘密码的回调，不返回进度，成功后会把生成的数据返回，如需使用需上传到服务端。
3. 增加了对三代锁的支持
4. 修复了之前sdk一些已知的bug，同时对其进行了优化。
5. 电量：通过getPower获取的电量值如果为-1，说明没有获取到电量，而不是电量为-1

