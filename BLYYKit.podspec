#
# Be sure to run `pod lib lint BLYYKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BLYYKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of BLYYKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'git@github.com:JonnyWorld/BLYYKit.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'baozhou' => 'baozhoua@163.com' }
  s.source           = { :git => 'git@github.com:JonnyWorld/BLYYKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'BLYYKit/Classes/**/*'
  
  
  s.vendored_frameworks = 'BLYYKit/Frameworks/yykit/YYKit.framework','BLYYKit/Frameworks/mars/mars.framework'

  
  s.libraries  = "c++", "z" , 'sqlite3'
  s.frameworks = 'Foundation', 'CoreTelephony', 'UIKit', 'CoreFoundation', 'CoreText', 'CoreGraphics', 'CoreImage', 'QuartzCore', 'ImageIO', 'AssetsLibrary', 'Accelerate', 'MobileCoreServices', 'SystemConfiguration'
  
  
  
  pod 'YBImageBrowser/Video', :git=>'https://gitee.com/big_front_end/YBImageBrowser.git', :commit =>'ab6aa8ca4d6948a8afe148064087172be746ff39'

  # s.resource_bundles = {
  #   'BLYYKit' => ['BLYYKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
