platform :ios, '9.0'

target 'RVCalendarWeekView' do

pod 'Collection'
pod 'EasyDate'
pod 'UIColor-HexString'
pod 'Masonry'

end

#To fix the masonry preprocessor definition
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'MAS_SHORTHAND=1'
        end
    end
end

