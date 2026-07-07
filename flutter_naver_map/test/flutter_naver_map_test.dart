import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_naver_map/flutter_naver_map_platform_interface.dart';
import 'package:flutter_naver_map/flutter_naver_map_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterNaverMapPlatform
    with MockPlatformInterfaceMixin
    implements FlutterNaverMapPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterNaverMapPlatform initialPlatform = FlutterNaverMapPlatform.instance;

  test('$MethodChannelFlutterNaverMap is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterNaverMap>());
  });

  test('getPlatformVersion', () async {
    FlutterNaverMap flutterNaverMapPlugin = FlutterNaverMap();
    MockFlutterNaverMapPlatform fakePlatform = MockFlutterNaverMapPlatform();
    FlutterNaverMapPlatform.instance = fakePlatform;

    expect(await flutterNaverMapPlugin.getPlatformVersion(), '42');
  });
}
