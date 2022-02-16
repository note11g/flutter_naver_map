#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint naver_map_plugin.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_naver_map'
  s.version          = '0.10.1'
  s.summary          = 'flutter naver map plugin'
  s.description      = <<-DESC
flutter naver map plugin
                       DESC
  s.homepage         = 'https://github.com/note11g/flutter_naver_map'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Kim Seung Bin' => 'note11@kakao.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'NMapsMap'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
