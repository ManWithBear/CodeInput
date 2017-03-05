Pod::Spec.new do |s|
  s.name             = 'CodeInput'
  s.version          = '0.1.0'
  s.license          = 'MIT'
  s.summary          = 'Code input control for iOS'
  s.homepage         = 'https://github.com/ManWithBear/CodeInput'
  s.author           = { 'Denis Bogomolov' => 'deni.bogomolov.github@ya.ru' }
  s.source           = { :git => 'https://github.com/ManWithBear/CodeInput.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Sources/**/*.swift'
end
