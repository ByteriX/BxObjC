

workspace 'BxObjC'

platform :ios, '5.0'




target 'iBXData' do

    project 'iBXData/iBXData.xcodeproj'

    use_frameworks!

    pod 'XMLDictionary', '1.4'

end

target 'iBXVcl' do
    
    project 'iBXVcl/iBXVcl.xcodeproj'
    
    use_frameworks!

    pod 'MBProgressHUD'
    
end

target 'iBXTest' do

    project 'iBXTest/iBXTest.xcodeproj'

    use_frameworks!

    pod 'XMLDictionary', '1.4'
    pod 'MBProgressHUD'
    pod 'ECSlidingViewController'

end

target 'iBXTestTests' do


    project 'iBXTest/iBXTest.xcodeproj'

    use_frameworks!

    pod 'XMLDictionary', '1.4'
    pod 'MBProgressHUD'
    pod 'ECSlidingViewController'

end

post_install do |installer|
    installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
               end
          end
   end
end
