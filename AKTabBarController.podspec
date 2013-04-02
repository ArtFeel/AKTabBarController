Pod::Spec.new do |s|
  s.name     = 'AKTabBarController'
  s.version  = '1.1.11'
  s.license  = 'MIT'
  s.summary  = 'AKTabBarController is an adaptive and customizable tab bar for iOS.'
  s.homepage = 'https://github.com/soundcloud/AKTabBarController'
  s.author   = { 'Ali Karagoz' => 'mail@alikaragoz.net' }
  s.source   = { :git => 'https://github.com/soundcloud/AKTabBarController.git', :tag => '1.1.11' }
  s.platform = :ios
  s.source_files = 'AKTabBarController'
  s.requires_arc = true
  s.framework = 'QuartzCore'
end
