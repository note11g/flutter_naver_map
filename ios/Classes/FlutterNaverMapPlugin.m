#import "FlutterNaverMapPlugin.h"
#if __has_include(<flutter_naver_map/flutter_naver_map-Swift.h>)
#import <flutter_naver_map/flutter_naver_map-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_naver_map-Swift.h"
#endif

@implementation FlutterNaverMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterNaverMapPlugin registerWithRegistrar:registrar];
}
@end
