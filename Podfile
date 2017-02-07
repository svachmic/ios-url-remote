platform :ios, '10.0'
use_frameworks!
inhibit_all_warnings!

target "URLRemote" do
	pod 'Alamofire', '~> 4.0'
	pod 'MBProgressHUD', '~> 1.0'
    pod 'Bond', '~> 5.0'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Firebase/Core'
    pod 'Firebase/Auth'
    pod 'Firebase/Database'
    pod 'GoogleSignIn'
    pod 'Material', '~> 2.0'
    pod 'ObjectMapper', '~> 2.0'

    target "URLRemoteTests" do
        inherit! :search_paths
        
        pod 'OHHTTPStubs'
        pod 'OHHTTPStubs/Swift'
    end

    post_install do |installer|
        installer.pods_project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end
end