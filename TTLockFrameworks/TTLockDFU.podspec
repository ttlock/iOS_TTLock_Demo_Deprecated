Pod::Spec.new do |s|
s.name          = "TTLockDFU"
s.version       = "2.8.9"
s.summary       = "TTLockDFU SDK for iOS."
s.homepage      = "https://github.com/ttlock/iOS_TTLock_Demo"
s.license       = { :type => "MIT", :file => "LICENSE" }
s.author        = { "ttlock" => "chensg@sciener.cn" }
s.platform      = :ios, "9.0"
s.source        = { :git => "https://github.com/ttlock/iOS_TTLock_Demo.git", :tag => "#{s.version}" }
s.preserve_paths      = "TTLockFrameworks/TTLockDFU.framework"
s.framework     = "CoreBluetooth"
s.library       = "z"
s.requires_arc  = true
s.swift_version   =  "4.0"
s.ios.deployment_target = "9.0"
s.dependency "ZIPFoundation", '~> 0.9.8'
s.dependency "iOSDFULibrary", '~> 4.3.0'
s.dependency "TTLock"
s.xcconfig     = { "OTHER_LDFLAGS" => "-ObjC" }
end
