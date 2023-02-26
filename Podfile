# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'eosMate' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
 
    pod 'Alamofire', '~> 4.7'
    pod 'SnapKit', '~> 5.0'
    pod 'SwiftyJSON'
    pod 'RealmSwift', '~> 3.20'
    pod 'RxSwift',    '~> 4.5'
    pod 'RxCocoa',    '~> 4.5'
    pod 'Moya/RxSwift', '~> 11.0'
    pod 'SwiftChart', '~> 1.0.1'
    pod 'Firebase/Core'
    pod 'Firebase/Messaging'
    pod "EosioSwift", "~> 0.4" # pod for this library
    # Providers for EOSIO SDK for Swift
    pod "EosioSwiftAbieosSerializationProvider", "~> 0.4" # serialization provider
    pod "EosioSwiftVaultSignatureProvider", "~> 0.4" # pod for this library
    
    post_install do |installer|
      installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
        end
      end
    end
    
    target 'eosMateTests' do
        inherit! :search_paths
        pod 'Firebase'
    end
end
