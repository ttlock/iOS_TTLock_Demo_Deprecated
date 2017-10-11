Pod::Spec.new do |s|
s.name         = "DFUDependence"
s.version      = "2.7.2"
s.summary      = "DFUDependence SDK for iOS."
s.homepage     = "https://github.com/ttlock/iOS_TTLock_Demo"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "ttlock" => "chensg@sciener.cn" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/ttlock/iOS_TTLock_Demo.git", :tag => "#{s.version}" }
s.vendored_frameworks = "TTLockFrameworks/DFUDependence.framework"
s.preserve_paths      = "TTLockFrameworks/DFUDependence.framework"
s.library   = "z"
s.requires_arc = true
s.xcconfig = { "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" => "YES" }
end


