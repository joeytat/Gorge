platform :ios, '9.0'

target 'Gorge' do
    use_frameworks!
    pod 'SnapKit'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxGesture'
    pod 'Reveal-iOS-SDK', :configurations => ['Debug']
    pod 'Bugly'
    pod 'Moya-ObjectMapper/RxSwift'
    pod 'Moya'
    pod 'RxOptional'
    pod 'RxRealm'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
