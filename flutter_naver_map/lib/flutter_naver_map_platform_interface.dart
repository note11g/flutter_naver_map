import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_naver_map_method_channel.dart';

abstract class FlutterNaverMapPlatform extends PlatformInterface {
  /// Constructs a FlutterNaverMapPlatform.
  FlutterNaverMapPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterNaverMapPlatform _instance = MethodChannelFlutterNaverMap();

  /// The default instance of [FlutterNaverMapPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterNaverMap].
  static FlutterNaverMapPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterNaverMapPlatform] when
  /// they register themselves.
  static set instance(FlutterNaverMapPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
