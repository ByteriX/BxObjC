#
#  Be sure to run `pod spec lint BxObjC.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "BxObjC"
  s.version      = "1.10.2"
  s.summary      = "Objective-C library for all"
  s.description  = "This framework will help iOS developers simplify development"
  s.homepage     = "https://github.com/ByteriX/BxObjC"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  s.author             = { "Sergey Balalaev" => "sof.bix@mail.ru" }
  # Or just: s.author    = "ByteriX"
  # s.authors            = { "ByteriX" => "email@address.com" }
  # s.social_media_url   = "http://twitter.com/ByteriX"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

s.platform     = :ios, "11.0"

#s.ios.deployment_target = "5.0"
#s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

s.source       = { :git => "https://github.com/ByteriX/BxObjC.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

s.subspec 'Common' do |cs|

    cs.frameworks = ["Foundation", "UIKit"]
    cs.resources = "**/iBXCommon/Resources/**/*.strings"
    cs.public_header_files = "**/iBXCommon/Frameworks/**/*.h", "**/iBXCommon/Sources/**/*.h"

    cs.source_files  = "**/iBXCommon/Frameworks/**/*.{h,m,c}", "**/iBXCommon/Sources/**/*.{h,m,c}"
    cs.exclude_files = "**/**Tests/**/*.*", "**/**Test/**/*.*"
    cs.requires_arc = ["**/BxPushNotificationMessageQueue.m"]
end

# deprecated
#s.subspec 'Data' do |ds|
#    ds.dependency 'BxObjC/Common'
#    ds.dependency 'XMLDictionary', '1.4'
#
#
#    ds.frameworks = ["Foundation", "UIKit"]
#    ds.public_header_files = "**/iBXData/Frameworks/**/*.h", "**/iBXData/Sources/**/*.h"
#
#    ds.source_files  = "**/iBXData/Frameworks/**/*.{h,m,c}", "**/iBXData/Sources/**/*.{h,m,c}"
#    ds.exclude_files = "**/**Tests/**/*.*", "**/**Test/**/*.*"
#    ds.requires_arc = []
#end

s.subspec 'DB' do |dbs|
    dbs.dependency 'BxObjC/Common'

### it need for SQLite BxDB
    dbs.xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => '$(inherited) SQLITE_CORE=1 SQLITE_UNICODE_ENABLE=1 SQLITE_ENABLE_FTS4=1 SQLITE_ENABLE_FTS4_PARENTHESIS=1' }
    dbs.frameworks = ["Foundation", "UIKit"]
    dbs.public_header_files = "**/iBXDB/Frameworks/**/*.h", "**/iBXDB/Sources/**/*.h"

    dbs.source_files  = "**/iBXDB/Frameworks/**/*.{h,m,c}", "**/iBXDB/Sources/**/*.{h,m,c}"
    dbs.exclude_files = "**/**Tests/**/*.*", "**/**Test/**/*.*"
    dbs.requires_arc = []
end

# deprecated
#s.subspec 'Map' do |ms|
#    ms.dependency 'BxObjC/Common'
#    ms.dependency 'BxObjC/Data'
#
#    ms.frameworks = ["Foundation", "UIKit", "MapKit", "CoreLocation"]
#    ms.public_header_files = "**/iBXMap/Frameworks/**/*.h", "**/iBXMap/Sources/**/*.h"
#
#    ms.source_files  = "**/iBXMap/Frameworks/**/*.{h,m,c}", "**/iBXMap/Sources/**/*.{h,m,c}"
#    ms.exclude_files = "**/**Tests/**/*.*", "**/**Test/**/*.*"
#    ms.requires_arc = []
#end

s.subspec 'Control' do |control|

  control.subspec 'Rate' do |rate|
    rate.frameworks = ["Foundation", "UIKit"]
    rate.public_header_files = "**/iBXVcl/Control/Rate/*.h"
    rate.source_files  = "**/iBXVcl/Control/Rate/*.{h,m,c}"
    rate.requires_arc = []
  end

  control.subspec 'TextView' do |textView|
    textView.frameworks = ["Foundation", "UIKit"]
    textView.public_header_files = "**/iBXVcl/Control/TextView/*.h"
    textView.source_files  = "**/iBXVcl/Control/TextView/*.{h,m,c}"
    textView.requires_arc = []
  end

  control.subspec 'ShakeAnimation' do |shakeAnimation|
    shakeAnimation.frameworks = ["Foundation", "UIKit"]
    shakeAnimation.public_header_files = "**/iBXVcl/Control/ShakeAnimation/*.h"
    shakeAnimation.source_files  = "**/iBXVcl/Control/ShakeAnimation/*.{h,m,c}"
  end

  control.subspec 'Navigation' do |navigation|
    navigation.dependency 'BxObjC/Common'
    navigation.dependency 'BxObjC/Control/ShakeAnimation'
    navigation.frameworks = ["Foundation", "UIKit"]
    navigation.public_header_files = "**/iBXVcl/Control/Navigation/**/*.h"
    navigation.source_files  = "**/iBXVcl/Control/Navigation/**/*.{h,m,c}"
  end

  # deprecated
  #control.subspec 'View' do |view|
  #  view.dependency 'BxObjC/Common'
  #  view.dependency 'BxObjC/Data'
  #  view.frameworks = ["Foundation", "UIKit"]
  #  view.public_header_files = "**/iBXVcl/Sources/View/**/*.h", "**/iBXVcl/Sources/ViewControl/**/*.h"
  #  view.source_files  = "**/iBXVcl/Sources/View/**/*.{h,m,c}", "**/iBXVcl/Sources/ViewControl/**/*.{h,m,c}"
  #  view.requires_arc = [
  #    "**/BxIconWorkspace**.m"
  #  ]
  #end

end

# deprecated
#s.subspec 'Vcl' do |vs|
#        vs.ios.deployment_target = '11.0'
#        vs.pod_target_xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '11.0' }
#    vs.dependency 'BxObjC/Common'
#    vs.dependency 'BxObjC/Data'
#    vs.dependency 'MBProgressHUD'
#    vs.dependency 'BxObjC/Control'
#
#    vs.frameworks = ["Foundation", "UIKit", "MapKit", "CoreLocation"]
#    vs.resources = "**/iBXVcl/**/*.{png,xib}"
#    vs.public_header_files = "**/iBXVcl/Frameworks/**/*.h", "**/iBXVcl/Sources/**/*.h"
#
#    vs.source_files  = "**/iBXVcl/Frameworks/**/*.{h,m,c}", "**/iBXVcl/Sources/**/*.{h,m,c}"
#    vs.exclude_files = "**/**Tests/**/*.*", "**/**Test/**/*.*"
#
#    vs.requires_arc = [
#        "**/BxIconWorkspace**.m",
#        "**/Navigation/**/*.*"
#    ]
#end



end
