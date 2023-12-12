# Uncomment the next line to define a global platform for your project
 platform :ios, '13.0'

target 'airbarknbark' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for airbarknbark

  pod 'SnapKit', '~> 5.0.0'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod 'MaterialComponents/TextControls+OutlinedTextAreas'
  pod 'MaterialComponents/TextControls+OutlinedTextFields'
  pod 'MaterialComponents/Dialogs'
  pod 'MDFInternationalization'
  pod 'MaterialComponents/Ripple'
  pod 'RxDataSources', '~> 5.0'
  pod "RxGesture"
  pod "BSImagePicker", "~> 3.1"
  pod 'IQKeyboardManagerSwift', '6.5.0'
  pod 'AlamofireNetworkActivityLogger', '~> 3.4'
  pod 'Alamofire' , '~> 5.0'
  pod 'SVProgressHUD'
  pod 'SDWebImage', '~> 5.0'
  pod 'Socket.IO-Client-Swift', '~> 16.0.1'
  pod "RxRealm"
  pod 'RangeSeekSlider', '~> 1.8'
  pod 'BottomPopup'
  pod 'Firebase/Messaging'
  pod 'Firebase/Crashlytics'
  pod 'SwiftLocation', '~> 4.0'
  pod 'Lightbox'
  pod 'SwiftyStoreKit'
  pod 'TPInAppReceipt'
  

  post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
          
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
        end
    end
  end
end
