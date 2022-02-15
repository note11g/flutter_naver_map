#import "NaverMapPlugin.h"
#if __has_include(<naver_map_plugin/naver_map_plugin-Swift.h>)
#import <naver_map_plugin/naver_map_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "naver_map_plugin-Swift.h"
#endif

@implementation NaverMapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftNaverMapPlugin registerWithRegistrar:registrar];
}
@end
