Pod::Spec.new do |s|
s.name          = "TTLock"
s.version       = "2.7.5"
s.summary       = "TTLock SDK for iOS."
s.homepage      = "https://github.com/ttlock/iOS_TTLock_Demo"
s.license       = { :type => "MIT", :file => "LICENSE" }
s.author        = { "ttlock" => "chensg@sciener.cn" }
s.platform      = :ios, "8.0"
s.source        = { :git => "https://github.com/ttlock/iOS_TTLock_Demo.git", :tag => "#{s.version}" }
s.vendored_frameworks = "TTLockFrameworks/TTLock.framework"
s.preserve_paths      = "TTLockFrameworks/TTLock.framework"
s.framework     = "CoreBluetooth"
s.library       = "z"
s.requires_arc  = true
s.xcconfig = { "ENABLE_BITCODE" => "NO" } 
end
