platform :ios, '9.0'
use_frameworks!

target "URLRemote" do
	pod 'Alamofire', '~> 4.0'
	pod 'MBProgressHUD', '~> 1.0'
    pod 'Bond', '~> 5.0'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Core'
end

target "URLRemoteTests" do
    pod 'OHHTTPStubs'
    pod 'OHHTTPStubs/Swift'
    pod 'Alamofire', '~> 4.0'
    pod 'Bond', '~> 5.0'
    pod 'Firebase/Core'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end