platform :ios, '9.0'
use_frameworks!

workspace 'UnsplashSwift'

target 'UnsplashSwift iOS' do
  xcodeproj 'UnsplashSwift.xcodeproj'
  pod 'Alamofire', '3.2.0'
end

target 'UnsplashSwift iOS Tests' do
  xcodeproj 'UnsplashSwift.xcodeproj'
end

target 'iOS Example' do
  xcodeproj 'Example/iOS Example.xcodeproj'
  pod 'UnsplashSwift', :path => '.'
  pod 'Alamofire', '3.2.0'
  pod 'AlamofireImage', '2.3.0'
end
