Pod::Spec.new do |s|
  s.name         = "UnsplashSwift"
  s.version      = "1.0.0"
  s.summary      = "Unsplash Swift SDK"
  s.homepage     = "TODO"
  s.license      = "MIT"
  s.author       = { "Camden Fullmer" => "camdenfullmer@gmail.com" }
  s.source    = { :git => "TODO", :tag => s.version }

  s.ios.deployment_target = "9.0"

  s.dependency "Alamofire", "3.2.0"

  s.source_files = 'Source/*.{swift,h}'
end
