import "dart:io";
import "dart:typed_data";

import "package:flutter_naver_map/src/util/image_util.dart";
import "package:flutter_test/flutter_test.dart";
import "package:path_provider_platform_interface/path_provider_platform_interface.dart";
import "package:plugin_platform_interface/plugin_platform_interface.dart";

class _FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  _FakePathProvider(this.path);

  final String path;

  @override
  Future<String?> getTemporaryPath() async => "$path/cache";

  @override
  Future<String?> getApplicationSupportPath() async => "$path/files";
}

void main() {
  late Directory tempRoot;

  // ImageUtil 은 폴더를 static 으로 기억하므로 앱 한 번 실행처럼 루트를 하나만 쓴다.
  setUpAll(() {
    tempRoot = Directory.systemTemp.createTempSync("fnm_image_util_test");
    Directory("${tempRoot.path}/cache").createSync();
    Directory("${tempRoot.path}/files").createSync();
    PathProviderPlatform.instance = _FakePathProvider(tempRoot.path);
  });

  tearDownAll(() {
    if (tempRoot.existsSync()) tempRoot.deleteSync(recursive: true);
  });

  // 앱 시작 직후 여러 마커 비트맵이 동시에 저장되면 임시 폴더 초기화가 여러 번 돌고,
  // 각 초기화가 다른 호출이 방금 만든 폴더를 "이전 폴더"로 보고 지웠다.
  // 그러면 저장 실패(PathNotFoundException)나, 지워진 폴더를 기억해 이후 저장이 모두 실패했다.
  test("동시에 처음 저장해도 모든 이미지 파일이 남고, 이후 저장도 된다", () async {
    final bytes = Uint8List.fromList(List.filled(64, 7));

    final paths = await Future.wait(
      List.generate(20, (i) => ImageUtil.saveImage(bytes, "concurrent_$i")),
    );
    // 초기화에서 시작된 이전 폴더 정리(fire-and-forget)가 끝날 시간을 준다.
    await Future<void>.delayed(const Duration(milliseconds: 200));

    for (final path in paths) {
      expect(File(path).existsSync(), isTrue, reason: path);
    }
    expect(paths.map((p) => File(p).parent.path).toSet(), hasLength(1));

    final later = await ImageUtil.saveImage(bytes, "after_init");
    expect(File(later).existsSync(), isTrue);
  });

  // 저장공간이 부족하면 Android 가 앱 실행 중에도 캐시 폴더를 지운다.
  // 이미지가 캐시 폴더에 있으면 저장된 아이콘 파일이 사라지고, 폴더를 다시 만들지
  // 않으면 이후 저장도 모두 실패해 앱을 다시 켤 때까지 지도에 아이콘이 뜨지 않았다.
  test("이미지는 캐시 폴더가 아닌 앱 전용 폴더에 저장되어 캐시 정리에 지워지지 않는다", () async {
    final bytes = Uint8List.fromList(List.filled(64, 3));
    final path = await ImageUtil.saveImage(bytes, "outside_cache");

    expect(path, startsWith("${tempRoot.path}/files/"));
    Directory("${tempRoot.path}/cache").deleteSync(recursive: true); // OS 캐시 정리
    expect(File(path).existsSync(), isTrue);
  });

  test("실행 중 이미지 폴더가 지워져도 다음 저장은 폴더를 다시 만들어 성공한다", () async {
    final bytes = Uint8List.fromList(List.filled(64, 5));
    final first = await ImageUtil.saveImage(bytes, "before_purge");
    File(first).parent.deleteSync(recursive: true);

    final next = await ImageUtil.saveImage(bytes, "after_purge");
    expect(File(next).existsSync(), isTrue);
  });
}
