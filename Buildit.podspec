Pod::Spec.new do |s|
  s.name         = "Buildit"
  s.version      = "1.0.0"
  s.summary      = "Elegant URL request construction for Swift 3."
  s.homepage     = "http://cocoapatterns.com"
  s.license      = 'MIT'
  # s.license      = { :type => "MIT", :file => "LICENSE" }
  s.social_media_url   = "http://twitter.com/cocoapatterns"
  s.author             = { "Ioakeim Lazakis" => "ilazakis@gmail.com" }

  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.11"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/ilazakis/Buildit.git", :tag => "#{s.version}" }
  s.source_files  = 'Sources/*.swift'
end