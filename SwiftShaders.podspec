Pod::Spec.new do |s|
  s.name             = 'SwiftShaders'
  s.version          = '1.0.0'
  s.summary          = 'Metal shader library for visual effects in SwiftUI.'
  s.description      = 'SwiftShaders provides Metal shaders for stunning visual effects in SwiftUI applications.'
  s.homepage         = 'https://github.com/muhittincamdali/SwiftShaders'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Muhittin Camdali' => 'contact@muhittincamdali.com' }
  s.source           = { :git => 'https://github.com/muhittincamdali/SwiftShaders.git', :tag => s.version.to_s }
  s.ios.deployment_target = '15.0'
  s.swift_versions = ['5.9', '5.10', '6.0']
  s.source_files = 'Sources/**/*.swift'
  s.frameworks = 'Foundation', 'SwiftUI', 'Metal'
end
