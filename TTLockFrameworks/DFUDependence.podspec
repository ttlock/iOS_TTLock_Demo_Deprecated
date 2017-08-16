Pod::Spec.new do |s|
s.name         = "DFUDependence"
s.version      = "2.7"
s.summary      = "DFUDependence SDK for iOS."
s.homepage     = "https://github.com/ttlock/iOS_TTLock_Demo"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "ttlock" => "chensg@sciener.cn" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/ttlock/iOS_TTLock_Demo.git", :tag => "#{s.version}" }
s.source_files  = "TTLockFrameworks/DFUDependence.framework/Headers/*.{h}" 
s.preserve_paths = "TTLockFrameworks/DFUDependence.framework/*"

