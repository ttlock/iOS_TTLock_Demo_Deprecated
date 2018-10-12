Pod::Spec.new do |s|
s.name          = "TTLockDFU"
s.version       = "2.8.3"
s.summary       = "TTLockDFU SDK for iOS."
s.homepage      = "https://github.com/ttlock/iOS_TTLock_Demo"
s.license       = { :type => "MIT", :file => "LICENSE" }
s.author        = { "ttlock" => "chensg@sciener.cn" }
s.platform      = :ios, "8.0"
s.source        = { :git => "https://github.com/ttlock/iOS_TTLock_Demo.git", :tag => "#{s.version}" }
s.vendored_frameworks = "TTLockFrameworks/TTLockDFU.framework"
s.preserve_paths      = "TTLockFrameworks/TTLockDFU.framework"
s.framework     = "CoreBluetooth"
s.library       = "z"
s.requires_arc  = true
s.dependency "DFUDependence"
s.dependency "TTLock"
end
