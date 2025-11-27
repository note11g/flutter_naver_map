#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_naver_map.podspec` to validate before publishing.

Pod::Spec.new do |s|
  s.name             = 'flutter_naver_map'

  s.version          = '1.4.0'
  s.summary          = 'flutter naver map plugin'
  s.description      = <<-DESC
flutter naver map plugin
                       DESC
  s.homepage         = 'https://github.com/note11g/flutter_naver_map'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'note11g' => 'note11@kakao.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_naver_map/Sources/flutter_naver_map/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'NMapsMap','3.22.1'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
